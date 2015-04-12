# == Schema Information
#
# Table name: involvements
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  ministry_id :integer          not null
#  status      :integer          default("0"), not null
#  level       :integer          default("0"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_involvements_on_ministry_id_and_level    (ministry_id,level)
#  index_involvements_on_user_id_and_ministry_id  (user_id,ministry_id)
#

class Involvement < ActiveRecord::Base
  enum status: [ :active, :inactive ]
  enum level:  [ :member, :volunteer, :leader, :editor ]
  
  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  default_scope ->{ where(status: :active) }
  

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :user
  belongs_to :ministry
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :user_id, :ministry_id
end
