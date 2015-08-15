require "rails_helper"

RSpec.describe NewApprovalRequestMailer, :type => :mailer do
  before(:all) do
    @post = create(:post)
    @approval_requests = 3.times.map { create(:approval_request, post:@post) }
    @approval_request = @approval_requests.last
    @ministry = @approval_request.ministry
    @peers = @approval_request.peers
    @sender = @approval_request.user
  end

  subject { NewApprovalRequestMailer.request_approval(@approval_request.to_findable_hash) }
  let(:run!) {subject.deliver_now}

  it 'should send from the @post.author Cornerstone DO NOT REPLY' do
    expect(subject.header['From'].to_s).to eq( "#{@sender.first_name} from Cornerstone <do-not-reply@cornerstonesf.org>")
  end

  it 'should have a subject' do
    expect(subject.subject).to_not be_nil
    expect(subject.subject).to match(@ministry.name)
  end

  it 'should send to all the peers' do
    expect(subject.to).to eq(@peers.map(&:user).map(&:email))
    expect { run! }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'CCs the post author' do
    expect(subject.cc).to eq([@sender.email])
  end

  describe "email body" do
    subject { NewApprovalRequestMailer.request_approval(@approval_request.to_findable_hash).body.encoded }

    it { is_expected.to match(Rails.application.routes.url_helpers.admin_post_url(@approval_request.post)) }
    it { is_expected.to match(@post.title) }
    it { is_expected.to match(@post.description) }

    describe "Post::Link section" do
      it { is_expected.to match(@post.url) }
    end

    describe "Post::Event section" do
      before(:all) do
        @post = create(:post_event)
        @approval_request = create(:approval_request, post:@post)
      end

      it { is_expected.to match(@post.combined_event_time_obj.to_s) }
      it { is_expected.to match(@post.location) }
    end

    describe "Post::Photo section" do
      before(:all) do
        @post = create(:post_photo)
        @approval_request = create(:approval_request, post:@post)
      end

      it { is_expected.to match(/Photo Count:\s*#{@post.uploaded_files.count}/) }
    end
  end
end
