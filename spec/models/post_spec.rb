# == Schema Information
#
# Table name: posts
#
#  id                  :integer          not null, primary key
#  type                :text             not null
#  public_id           :string(21)       not null
#  parent_id           :integer
#  ministry_id         :integer          not null
#  user_id             :integer          not null
#  title               :text             not null
#  description         :text
#  display_options     :jsonb            default("{}"), not null
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  poster_original_url :string
#  rejected_at         :datetime
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_public_id    (public_id) UNIQUE
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

require 'rails_helper'

RSpec.describe Post, :type => :model do
  subject { build(:post, ministry:@ministry) }

  it { should belong_to(:ministry) }
  it { should have_many(:approval_requests) }
  it { should have_many(:approvers) }
  it { should have_one(:draft) }


  before(:all) do
    @ministry = create(:populated_ministry)
  end

  subject { build_stubbed(:post, ministry:@ministry, author:@ministry.members.first) }

  it "builds from factory", :internal do
    [:post, :post_event, :post_link, :post_page, :post_photo, :post_video].each do |factory|
      expect { create(factory) }.to_not raise_error
    end
  end

  describe 'accepts_nested_attributes_for :comm_arts_request' do
    it 'rejects_if design_requested && print_[attrs] are zero' do
      expect(subject.comm_arts_request).to be_nil
    end

    [:design_purpose, :design_tone, :design_cta, :notes, :postcard_quantity, :badges_quantity, :booklet_quantity, :poster_quantity].each do |attr|
      it "creates if #{attr} is true" do
        hash = {design_purpose:"", design_tone:"", design_cta:"", notes:"", postcard_quantity:"", badges_quantity: "", booklet_quantity: "", poster_quantity: ""}
        hash[attr] = "1"

        subject.comm_arts_request_attributes = hash
        expect(subject.comm_arts_request).not_to be_nil
      end
    end
  end

  describe '[scope]current' do
    let!(:unpublished) { create(:post, ministry:@ministry, author:@ministry.members.first) }
    let!(:published) { create(:post, published_at:2.days.ago, ministry:@ministry, author:@ministry.members.first) }
    let!(:expired) { create(:post, expired_at:1.days.ago, published_at:2.days.ago, ministry:@ministry, author:@ministry.members.first) }

    it 'filteres unpublished and expired posts' do
      current_ids = Post.current.pluck(:id)
      expect(current_ids).to include published.id
      expect(current_ids).to_not include unpublished.id
      expect(current_ids).to_not include expired.id
    end
  end

  describe '[scope]relevance_order' do
    before(:all) do
      @post_a, @post_b, @post_c = @posts = 3.times.map {|i| create(:post, expired_at:nil, published_at:(Time.now - (i+1).days), ministry:@ministry, author:@ministry.members.first)}
    end

    it 'content posts sort downward with age' do
      expect( Post.relevance_order.pluck(:id) ).to eq(@posts.map(&:id))
    end

    it 'expireing posts are sorted by the time until the post expires' do
      @post_b.update_attribute :expired_at, Time.now
      expect(Post.relevance_order.first.id).to eq(@post_b.id)
      @post_b.update_attribute :expired_at, Time.now + 6.months
      expect(Post.relevance_order.pluck(:id).last).to eq(@post_b.id)
    end
  end

  describe '#find_approvers ' do
    it 'returns an array of Users' do
      expect(subject.find_approvers.first).to be_a User
      expect(subject.find_approvers.count).to eq(6)
    end

  end

  describe '#request_approval!' do
    subject { create(:post, ministry:@ministry, author:@ministry.members.sample) }

    it 'is creates ApprovalRequests on create callback' do
      expect(subject.approval_requests.where(status: 0).count).to eq(6)
    end

    it 'creates an approved ApprovalRequest for the author' do
      approved = subject.approval_requests.where(status: 1).all
      expect(approved.length).to eq(1)
      expect(approved.first.user).to eq(subject.author)
    end
  end
end
