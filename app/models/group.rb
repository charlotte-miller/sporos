# == Schema Information
#
# Table name: groups
#
#  id                      :integer          not null, primary key
#  state                   :string(50)       not null
#  name                    :string           not null
#  description             :text             not null
#  is_public               :boolean          default("true")
#  meets_every_days        :integer          default("7")
#  meetings_count          :integer          default("0")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :text             not null
#  study_id                :integer
#  approved_at             :datetime
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  study_group_data        :jsonb            default("{}"), not null
#  book_group_data         :jsonb            default("{}"), not null
#  affinity_group_data     :jsonb            default("{}"), not null
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#  index_groups_on_study_id             (study_id)
#  index_groups_on_type_and_id          (type,id)
#

class Group < ActiveRecord::Base
  include AttachableFile

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  # attr_accessible :description, :name, :is_public, :state, :meets_every_days, :poster_img, :poster_img_remote_url
  # attr_accessible :members, :members_attributes,  as: 'leader'
  attr_protected #none

  has_attachable_file :poster_img,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      :processors => [:thumbnail, :paperclip_optimizer],
                      paperclip_optimizer: { jhead:true, jpegrecompress:true, jpegtran:true },
                      :styles => {
                        large:        { geometry: "1500x1500>", format: 'jpg', convert_options: "-strip" },
                        medium:       { geometry: "500x500>",   format: 'jpg', convert_options: "-strip" },
                        small:        { geometry: "200x200>",   format: 'jpg', convert_options: "-strip" },
                        large_thumb:  { geometry: "120x120#",   format: 'jpg', convert_options: "-strip" },
                        thumb:        { geometry: "100x100#",   format: 'jpg', convert_options: "-strip" }
                      }

  process_in_background :poster_img

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :study
  has_one  :current_meeting,    -> { where state: 'current'},  :class_name => "Meeting", foreign_key: 'group_id'
  has_many :meetings,           :dependent => :destroy,        :class_name => "Meeting", foreign_key: 'group_id'
  has_many :questions,          as: 'source'
  has_many :lessons,            through: :study

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
