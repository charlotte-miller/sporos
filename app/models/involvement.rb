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
#  index_involvements_on_user_id_and_ministry_id  (user_id,ministry_id) UNIQUE
#

class Involvement < ActiveRecord::Base
  enum status: [ :active, :inactive ]
  enum level:  [ :member, :volunteer, :leader, :editor ]

  attr_protected #none - using strong params

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  default_scope ->{ where('status=0') }
  scope :in_ministry, -> (ministry){where(ministry: ministry)}

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :user
  belongs_to :ministry


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of   :user_id, :ministry_id
  validates_associated    :user, :ministry, :on => :create
  validates_uniqueness_of :ministry_id, scope:[:user_id]


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------

  def more_involved_in_this_ministry
    User.joins(:involvements)
    .where(['involvements.ministry_id = ? AND involvements.level > ?', self.ministry_id, self[:level] ])
    .all
  end

  def level_id=(id)
    self[:level]= id
  end
end
