# == Schema Information
#
# Table name: block_requests
#
#  id            :integer          not null, primary key
#  admin_user_id :integer
#  user_id       :integer          not null
#  source_id     :integer          not null
#  source_type   :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_block_requests_on_source_id_and_source_type  (source_id,source_type)
#  index_block_requests_on_user_id                    (user_id)
#

class BlockRequest < ActiveRecord::Base
  include SourceableModels
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  # attr_accessible :requester, :approver, :source
  
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :requester, :class_name  => "User",        :foreign_key => "user_id"
  belongs_to :approver,  :class_name  => "AdminUser",   :foreign_key => "admin_user_id"
  belongs_to :source,    :polymorphic =>  true,        :counter_cache => true
  # has_one  :author,    :class_name => "user", :through => :source
  
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :requester, :approver, :source
  
  
  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  def offender
    source.author
  end
end
