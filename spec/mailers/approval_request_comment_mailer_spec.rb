require "rails_helper"

RSpec.describe ApprovalRequestCommentMailer, :type => :mailer do
  before(:all) do
    @post = create(:post)
    @approval_requests = 3.times.map { create(:approval_request, post:@post) }
    @approval_request = @approval_requests.last
    @peers = @approval_request.peers
    @sender = @approval_request.user
    @comment_body = Faker::Lorem.sentence(5)
  end

  describe "notify_all" do
    let(:mail) { ApprovalRequestCommentMailer.notify_all(@approval_request.to_findable_hash, @comment_body) }
    let(:run!) {mail.deliver_now}

    it 'should send from the @comment.author Cornerstone DO NOT REPLY' do
      expect(mail.header['From'].to_s).to eq( "#{@sender.first_name} from Cornerstone <do-not-reply@cornerstonesf.org>")
    end

    it 'subject should be "Comments on #{@post.title}"' do
      expect(mail.subject).to eq("Comments on #{@post.title}")
    end

    it 'should send to all the peers' do
      expect(mail.to).to eq(@peers.map(&:user).map(&:email))
      expect { run! }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'CCs the comment author' do
      expect(mail.cc).to eq([@sender.email])
    end

    describe "email body" do
      it 'should include a link to the post' do
        expect(mail.body.encoded).to match(Rails.application.routes.url_helpers.post_url(@approval_request.post))
      end

      it 'should include the comment body' do
        expect(mail.body.encoded).to match(@comment_body)
      end
    end

  end

end
