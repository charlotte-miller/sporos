# == Schema Information
#
# Table name: approval_requests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  post_id          :integer          not null
#  status           :integer          default("0"), not null
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

class ApprovalRequest < ActiveRecord::Base
  include Commentable

  # attr_accessible :user, :user_id, :post, :post_id, :status, :comment_threads_attributes
  enum status: [ :pending, :accepted, :rejected, :archived ].freeze

  def as_json(options={})
    super({only:[:id, :user_id, :post_id, :status], include:[comment_threads:{only:[:id, :user_id], methods:[:text]}]}.merge(options))
  end

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :user
  belongs_to :post

  has_one :ministry, through: :post

  has_one :author, :class_name => "User", through: :post, source: :author

  has_many :peers, -> (obj) { where("id != ?", obj.id) },class_name:'ApprovalRequest', foreign_key:'post_id', primary_key:'post_id'

  # FROM Commentable
  # has_many :comment_threads, :class_name => "Comment", :as => :commentable
  has_many :unread_comments, -> (obj){ where(["comments.created_at > ?", obj.last_vistited_at]) }, :class_name => "Comment", :as => :commentable


  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  scope :current, -> { where('status < 3') }
  scope :decided, -> { where('status = 1 OR status = 2') }
  scope :action_required, -> { where('status = 0 OR status = 2') }


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of   :user_id, :post_id, :last_vistited_at
  validates_associated    :user,    :post,    :on => :create
  validates_uniqueness_of :post_id, scope:[:user_id]


  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  before_validation :set_last_vistited_at
  after_create :send_notification
  before_update :check_for_concensus

  def set_last_vistited_at
    self.last_vistited_at ||= Time.now
  end

  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------

  def is_author?
    author == user
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
      reject_post!

    elsif is_accepted  = results.include?('accepted') && required_districts <= supporting_districts
      publish_post!

    else
      # not enough votes... do nothing
    end
  end

  def current_concensus(mark_author=false)
    votes = [self] | peers
    concensus_hash = votes.group_by do |vote|
      voters_involvement = Involvement.where(ministry: post.ministry, user:vote.user)
      group_name = voters_involvement.first.level.upcase
      (mark_author && (vote.user_id == post.user_id))  ? 'AUTHOR' : group_name
    end

    concensus_hash.each do |key, votes|
      if votes.find(&:rejected?)
        concensus_hash[key]= 'rejected'
      elsif supporter = votes.find(&:accepted?)
        concensus_hash[key]= 'accepted'
      else
        concensus_hash[key]= 'undecided'
      end
    end

    concensus_hash
  end

  def reject_post!
    if post.rejected_at.nil?
      #send notification to author
    end

    self.post.touch :rejected_at
    archive_unchecked_requests
  end

  def publish_post!
    self.post.touch :published_at
    archive_unchecked_requests
  end

  def archive_unchecked_requests
    self.peers.where('status = 0').update_all('status = 3')
  end

  def add_a_comment(text)
    self.add_comment comment = Comment.create(body:text, user_id:user_id)
    return comment
  end

private

  # after_create
  def send_notification
    ApprovalRequestMailer.open_approval_request(self.to_findable_hash).deliver_later
  end

end
