require "rails_helper"

RSpec.describe NewApprovalRequestMailer, :type => :mailer do
  before(:all) do
    @post = create(:post)
    @approval_requests = 3.times.map { create(:approval_request, post:@post) }
    @approval_request = @approval_requests.last
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
  end

  it 'should send to all the peers' do
    expect(subject.to).to eq(@peers.map(&:user).map(&:email))
    expect { run! }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'CCs the post author' do
    expect(subject.cc).to eq([@sender.email])
  end

  describe "email body" do
    it 'should include a link to the post' do
      expect(subject.body.encoded).to match(Rails.application.routes.url_helpers.post_url(@approval_request.post))
    end
  end
end
