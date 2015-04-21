# == Schema Information
#
# Table name: approval_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  post_id    :integer          not null
#  status     :integer          default("0"), not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_approval_requests_on_post_id              (post_id)
#  index_approval_requests_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#  index_approval_requests_on_user_id_and_status   (user_id,status)
#

class ApprovalRequest < ActiveRecord::Base
  attr_accessible :user, :user_id, :post, :post_id, :status
  enum status: [ :pending, :accepted, :rejected, :archived ].freeze
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------  
  belongs_to :user
  belongs_to :post
  
  has_one :author, :class_name => "User", through: :post, source: :author
  
  has_many :peers, class_name:'ApprovalRequest', foreign_key:'post_id', primary_key:'post_id'
  
    
  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------  
  scope :current, -> { where('status < 3') }
  scope :decided, -> { where('status = 1 OR status = 2') }
  
    
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------  
  validates_presence_of   :user_id, :post_id
  validates_associated    :user,    :post,    :on => :create
  validates_uniqueness_of :post_id, scope:[:user_id]
  
  
  # ---------------------------------------------------------------------------------
  # Callbacks
  # --------------------------------------------------------------------------------- 
  after_create :send_notification
  before_update :check_for_concensus
  
 
  # ---------------------------------------------------------------------------------
  # Methods
  # --------------------------------------------------------------------------------- 
  
  
  def send_notification
    # Mailer.ApprovalRequest.deliver(user)
    # 
  end
  
  def check_for_concensus
    return unless status_changed? && ['accepted', 'rejected'].include?( status )
    
    votes                 = [self] | peers.decided
    results               = votes.map(&:status).uniq
    supporting_districts  = votes.select(&:accepted?).map do |vote|
                              voters_involvement = Involvement.where(ministry: post.ministry, user:vote.user)
                              voters_involvement.first[:level]
                            end.uniq.length
    
    authors_level         = post.author.involvements.in_ministry(post.ministry).first[:level]
    required_districts    = 4 - (authors_level+1) # Leader, Editor
        
        
    if is_rejected  = results.include?('rejected')
      archive_unchecked_requests
      # send rejection notice

    elsif is_accepted  = results.include?('accepted') && required_districts <= supporting_districts
      publish_post!
      
    else
      # not enough votes... do nothing
    end
  end
  
  def publish_post!
    self.post.touch :published_at
    archive_unchecked_requests
  end
  
  def archive_unchecked_requests
    self.peers.where('status = 0').update_all('status = 3')
  end
end
