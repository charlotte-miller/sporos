# == Schema Information
#
# Table name: ministries
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  url_path    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ministries_on_name  (name) UNIQUE
#

class Ministry < ActiveRecord::Base

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  has_many :posts
  has_many :involvements
  
  has_many :members,                                        through: :involvements, source:'user'
  has_many :volunteers, ->{where 'involvements.level > 0'}, through: :involvements, source:'user'
  has_many :leaders,    ->{where 'involvements.level > 1'}, through: :involvements, source:'user'
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  
  validates_presence_of :name, :url_path
  
end
