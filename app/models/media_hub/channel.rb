# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  position   :integer          not null
#  title      :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_channels_on_position  (position)
#  index_channels_on_slug      (slug) UNIQUE
#

class Channel < ActiveRecord::Base
  include Sortable
  include Sluggable

  acts_as_listable
  slug_candidates :title, [:title, :year], [:title, :month, :year]

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------


  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------




end

# Support the namespacing convention for rake tasks etc.
MediaHub::Channel = Channel
