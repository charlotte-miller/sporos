# == Schema Information
#
# Table name: groups
#
#  id                        :integer          not null, primary key
#  state                     :string(50)       not null
#  name                      :string           not null
#  description               :text             not null
#  is_public                 :boolean          default("true")
#  meets_every_days          :integer          default("7")
#  meetings_count            :integer          default("0")
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  type                      :text             not null
#  study_id                  :integer
#  approved_at               :datetime
#  poster_image_file_name    :string
#  poster_image_content_type :string
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  poster_image_fingerprint  :string
#  poster_image_processing   :boolean
#  study_group_data          :jsonb            default("{}"), not null
#  book_group_data           :jsonb            default("{}"), not null
#  affinity_group_data       :jsonb            default("{}"), not null
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#  index_groups_on_study_id             (study_id)
#  index_groups_on_type_and_id          (type,id)
#

class Group < ActiveRecord::Base  
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_accessible :description, :name, :is_public, :state, :meets_every_days
  attr_accessible :members, :members_attributes,  as: 'leader'
  
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  has_one  :current_meeting,    -> { where state: 'current'},  :class_name => "Meeting", foreign_key: 'group_id'
  has_many :meetings,           :dependent => :destroy,        :class_name => "Meeting", foreign_key: 'group_id'
  has_many :questions,          as: 'source'
  
  has_many :members,            :through => :group_memberships
  # has_many :leaders,            :through => :group_memberships, source: 'member', conditions: 'group_memberships.role_level > 1'
  has_many :group_memberships,  :dependent => :destroy, inverse_of: :group
  accepts_nested_attributes_for :group_memberships, 
                                allow_destroy: true, 
                                reject_if: lambda { !(attributes[:members_attributes].try(:[], :user_id)) }
  
  
  def leaders; members.where('group_memberships.role_level > 1') ;end
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :name, :description, :state
  
  
  
  # ---------------------------------------------------------------------------------
  # StateMachine
  # ---------------------------------------------------------------------------------
  include AASM
  aasm column:'state' do #no_direct_assignment:true
    state :is_open, initial: true
    state :is_closed
    state :is_invite_only
  end
  

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  # scope :for_user, -> {|user| where(user)}
  scope :is_public,           -> {where(is_public: true)}
  scope :publicly_searchable, -> {is_public.is_open}

  
  
  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  # after_save :create_first_meeting
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  
end
