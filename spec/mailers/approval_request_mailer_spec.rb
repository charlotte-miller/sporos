require "rails_helper"

RSpec.describe ApprovalRequestMailer, :type => :mailer do
  before(:all) do
    @post = create(:post)
    @approval_requests = 3.times.map { create(:approval_request, post:@post) }
    @approval_request = @approval_requests.last
    @ministry = @approval_request.ministry
    @sender   =  @author = @approval_request.author
    @receiver = @approval_request.user
  end

  describe '#open_approval_request(approval_request)' do
    subject { ApprovalRequestMailer.open_approval_request(@approval_request.to_findable_hash) }
    let(:run!) {subject.deliver_now}

    it 'sends FROM the @post.author Cornerstone DO NOT REPLY' do
      expect(subject.header['From'].to_s).to eq( "#{@sender.first_name} from Cornerstone <do-not-reply@cornerstonesf.org>")
    end

    it 'sends TO @approval_request.user' do
      expect(subject.to).to eq([@receiver.email])
      expect { run! }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    describe "email body" do
      subject { ApprovalRequestMailer.open_approval_request(@approval_request.to_findable_hash).body.encoded }

      it { is_expected.to match(Rails.application.routes.url_helpers.admin_post_url(@approval_request.post)) }
      it { is_expected.to match(@post.title) }
    end

    context 'when the approver IS NOT the author' do
      describe 'email subject' do
        it 'includes the Ministry' do
          expect(subject.subject).to_not be_nil
          expect(subject.subject).to match(@ministry.name)
        end

        it 'includes the Post type' do
          expect(subject.subject).to_not be_nil
          expect(subject.subject).to match('Link')
        end
      end

      describe "email body" do
        subject { ApprovalRequestMailer.open_approval_request(@approval_request.to_findable_hash).body.encoded }
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

    context 'when the approver IS the author' do
      before(:all) do
        @approval_request = ApprovalRequest.find_by(user: @author, post:@post)
      end

      describe 'email subject' do
        it 'includes the @post.title' do
          expect(subject.subject).to_not be_nil
          expect(subject.subject).to match(@post.title)
        end
      end

      describe 'email body' do
        subject { ApprovalRequestMailer.open_approval_request(@approval_request.to_findable_hash).body.encoded }

        it { is_expected.to match('Thank you') }
        it { is_expected.to match(@post.ministry.name) }
      end
    end


  end

  describe '#close_approval_request(approval_request)' do
    subject { ApprovalRequestMailer.open_approval_request(@approval_request.to_findable_hash) }
    let(:run!) {subject.deliver_now}

    it 'has tests' do
      skip
    end
  end
end
