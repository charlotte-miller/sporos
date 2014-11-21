# == Schema Information
#
# Table name: groups
#
#  id               :integer          not null, primary key
#  state            :string(50)       not null
#  name             :string(255)      not null
#  description      :text(65535)      not null
#  is_public        :boolean          default("1")
#  meets_every_days :integer          default("7")
#  meetings_count   :integer          default("0")
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#

class Group < ActiveRecord::Base  
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  # attr_accessible :description, :name, :is_public, :state, :meets_every_days
  # attr_accessible :members, :members_attributes,  as: 'leader'
  
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  has_one  :current_meeting,    -> { where state: 'current'},  :class_name => "Meeting", foreign_key: 'group_id'
  has_many :meetings,           :dependent => :destroy,        :class_name => "Meeting", foreign_key: 'group_id'
  has_many :questions,          as: 'source'
  
  has_many :members,            :through => :group_memberships, source:'member', inverse_of: :groups  
  # has_many :leaders,            :through => :group_memberships, source: 'member', conditions: 'group_memberships.role_level > 1'
  has_many :group_memberships,  :dependent => :destroy
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
    state :open, initial: true
  end
  #   do
  #     def accepting_members?  ;true;  end
  #   end
  

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  # scope :for_user, -> {|user| where(user)}
  scope :is_currently,    lambda {|state| {:conditions => { :state => state.to_s }} }
  scope :is_public,           -> {where(is_public: true)}
  scope :publicly_searchable, -> {is_public.is_currently(:open)}

  
  
  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  # after_save :create_first_meeting
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  
end
