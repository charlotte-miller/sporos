# == Schema Information
#
# Table name: approval_requests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  post_id          :integer          not null
#  status           :integer          default("0"), not null
#  notes            :text
#  last_vistited_at :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_approval_requests_on_post_id              (post_id)
#  index_approval_requests_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#  index_approval_requests_on_user_id_and_status   (user_id,status)
#

require 'rails_helper'

RSpec.describe ApprovalRequest, :type => :model do
  before(:all) do
    @ministry = create(:populated_ministry)
  end
  
  subject { build(:approval_request) }

  it "builds from factory", :internal do
    expect { create(:approval_request) }.to_not raise_error
  end
  
  it { should belong_to(:post) }
  it { should belong_to(:user) }
  
  describe '#peers [association]' do
    before(:all) do
      @subject = create(:approval_request)
      @post  = @subject.post
      @peers = 3.times.map { create(:approval_request, post:@post) }
      @not_peer = create(:approval_request)
      @sample_peer = @peers.sample
    end
    
    it { should have_many(:peers) }
    
    it 'is an ApprovalRequest' do
      expect(@sample_peer).to be_a ApprovalRequest
    end
    
    it 'includes all ApprovalRequest for this post_id' do
      @peers.each {|peer| expect(@subject.peers).to include peer}
      expect(@subject.peers).to_not include @not_peer
    end
  end
  
  describe '#check_for_concensus' do
    
    before(:each) do
      @author ||= @ministry.volunteers.first
      @post = create(:post, ministry:@ministry, author: @author)
      @approval_requests = @post.approval_requests
      @subject = @approval_requests.first
      @leader1, @leader2, @editor1, @editor2 = @approval_requests
    end
    
    it 'checks on update' do
      expect(@subject).to receive :check_for_concensus
      @subject.accepted!
    end
    
    context 'CONCENSUS REACHED' do
      let(:run) { @approval_requests[1..2].map(&:accepted!) }
      
      it 'publishes the post' do
        run
        expect(@subject.post.published_at).to_not be_nil
      end
      
      context 'Volunteer post' do      
        it 'archives its peers ApprovalRequest' do
          run
          expect(ApprovalRequest.archived.count).to eq(2)
          expect(ApprovalRequest.accepted.count).to eq(3) #includes user
          @approval_requests[1..2].each {|request| expect(ApprovalRequest.accepted).to include request }
        end
      end
      
      context 'Leader post' do      
        before(:all) { @author = @ministry.leaders.first }
        
        it 'archives its peers ApprovalRequest' do
          @approval_requests.first.accepted!
          expect(ApprovalRequest.archived.count).to eq(1)
          expect(ApprovalRequest.accepted.count).to eq(2) #includes user
          expect(ApprovalRequest.accepted).to include @approval_requests.first
        end
      end
      
      context 'Editor post' do
        before(:all) { @author = @ministry.editors.first }

        it 'is instantly published' do
          expect(@post.published_at).to_not be_nil
        end
      end
    end

    context 'CONCENSUS REJECTED' do
      
      it 'archives all pending' do
        @leader1.rejected!
        expect(ApprovalRequest.archived.count).to eq(3)
      end
      
      it 'preserves other votes' do
        @leader2.accepted!
        @leader1.rejected!
        expect(ApprovalRequest.accepted.count).to eq(2) #includes user
        expect(ApprovalRequest.archived.count).to eq(2)
      end
      
      it 'touches post.rejected_at' do
        expect(@post.rejected_at).to be_nil
        @leader1.rejected!
        expect(@post.reload.rejected_at).to_not be_nil
      end
    end
  end
  
  describe '#unread_comments' do    
    before(:each) do
      @author ||= @ministry.volunteers.first
      @post = create(:post, ministry:@ministry, author: @author)
      @approval_requests = @post.approval_requests
      @subject = @approval_requests.first
      # @leader1, @leader2, @editor1, @editor2 = @approval_requests
      @comments = @approval_requests.first.comment_threads << 2.times.map { create(:comment)}
    end
    
    it 'returns comments that were created after last_vistited_at' do
      expect(@subject.unread_comments).to eq(@comments)
      @subject.touch(:last_vistited_at)
      expect(@subject.unread_comments.reload).to be_empty
    end
  end
end
