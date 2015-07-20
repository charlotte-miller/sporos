# == Schema Information
#
# Table name: comm_arts_requests
#
#  id                    :integer          not null, primary key
#  post_id               :integer
#  design_creative_brief :jsonb            default("{}"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  due_date              :datetime
#  archived_at           :datetime
#  todo                  :jsonb
#  print_quantity        :jsonb
#
# Indexes
#
#  index_comm_arts_requests_on_archived_at  (archived_at)
#  index_comm_arts_requests_on_post_id      (post_id)
#

require 'rails_helper'

RSpec.describe CommArtsRequest, :type => :model do
  subject { create(:comm_arts_request) }

  it "builds from factory", :internal do
    expect { create(:comm_arts_request) }.to_not raise_error
  end

  describe 'design_purpose setters' do
    it 'creates setter methods for :design_purpose, :design_tone, :design_cta' do
      [:design_purpose, :design_tone, :design_cta].each do |virtual_attr|
        subject.send("#{virtual_attr}=", 'blark')
        expect(subject.send(virtual_attr)).to eq('blark')
      end
    end
  end

  describe 'ministry_with_fallback' do
    it 'returns the ministry associated with post' do
      expect(subject.ministry_with_fallback).to eq(subject.ministry)
    end

    describe 'without a post' do
      subject { create(:comm_arts_request, post: nil, todo: { ministry_id: ministry.id }) }
      let(:ministry) { create :ministry }
      it 'returns ministry from ministry_id' do
        expect(subject.ministry_with_fallback).to eq(ministry)
      end
    end
  end

  describe 'user_with_fallback' do
    it 'returns the user associated with post' do
      expect(subject.user_with_fallback).to eq(subject.author)
    end

    describe 'without a post' do
      subject { create(:comm_arts_request, post: nil, todo: { author_id: author.id }) }
      let(:author) { create :user }
      it 'returns ministry from author_id' do
        expect(subject.user_with_fallback).to eq(author)
      end
    end
  end

  describe 'title_with_fallback' do
    it 'returns the title associated with post' do
      expect(subject.title_with_fallback).to eq(subject.post.title)
    end

    describe 'without a post' do
      subject { create(:comm_arts_request, post: nil, todo: { title: title }) }
      let(:title) { Faker::Lorem.sentence(5) }
      it 'returns title from todo' do
        expect(subject.title_with_fallback).to eq(title)
      end
    end
  end
end
