# == Schema Information
#
# Table name: stars
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  source_id   :integer          not null
#  source_type :string(50)       not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_stars_on_source_id_and_source_type  (source_id,source_type)
#  index_stars_on_user_id                    (user_id)
#

class Star < ActiveRecord::Base
  attr_accessible :source, :user_id
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_accessible :homepage, :name

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :user
  belongs_to :source,   :polymorphic =>  true,    :counter_cache => true


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :user, :source


  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------



  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
end
