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
#  index_channels_on_position  (position) UNIQUE
#  index_channels_on_slug      (slug) UNIQUE
#

class Channel < ActiveRecord::Base
  include Sluggable
  slug_candidates :title, [:title, :year], [:title, :month, :year]
  
  acts_as_list
end
