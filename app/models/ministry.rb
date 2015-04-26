# == Schema Information
#
# Table name: ministries
#
#  id          :integer          not null, primary key
#  slug        :string           not null
#  name        :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ministries_on_name  (name) UNIQUE
#  index_ministries_on_slug  (slug) UNIQUE
#

class Ministry < ActiveRecord::Base
  include Sluggable
  slug_candidates :name
  
  attr_protected #none - using strong params
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  has_many :posts,        dependent: :destroy, inverse_of: :ministry
  has_many :involvements, dependent: :destroy, inverse_of: :ministry
  
  has_many :users,      through: :involvements
  has_many :members,    ->{where 'involvements.level' => 0}, through: :involvements, source:'user'
  has_many :volunteers, ->{where 'involvements.level' => 1}, through: :involvements, source:'user'
  has_many :leaders,    ->{where 'involvements.level' => 2}, through: :involvements, source:'user'
  has_many :editors,    ->{where 'involvements.level' => 3}, through: :involvements, source:'user'
  
  has_many :more_involved_than_a_members,    ->{where 'involvements.level > 0'}, through: :involvements, source:'user'
  has_many :more_involved_than_a_volunteers, ->{where 'involvements.level > 1'}, through: :involvements, source:'user'
  has_many :more_involved_than_a_leaders,    ->{where 'involvements.level > 2'}, through: :involvements, source:'user'
  has_many :more_involved_than_a_editors,    ->{where 'involvements.level > 3'}, through: :involvements, source:'user'
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of   :name, :slug
  validates_uniqueness_of :name, :slug
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
end
