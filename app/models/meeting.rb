# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null
#  lesson_id  :integer          not null
#  position   :integer          default("0"), not null
#  state      :string(50)       not null
#  date_of    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_meetings_on_group_id_and_position  (group_id,position)
#  index_meetings_on_group_id_and_state     (group_id,state)
#  index_meetings_on_lesson_id              (lesson_id)
#

class Meeting < ActiveRecord::Base
  

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_accessible :date_of, :group_id, :lesson_id, :state
  acts_as_list scope: :group   
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :group, counter_cache: true
  belongs_to :lesson, class_name:'Lesson'
  has_many :questions, as: 'source', inverse_of: :source  #:dependent => :nullify  # really repoint at question if public
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :group, :lesson
  
  
  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  
  # def to_param; group.is_public ? position : id  ;end
end
