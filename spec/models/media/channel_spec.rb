# == Schema Information
#
# Table name: media_channels
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
#  index_media_channels_on_position  (position) UNIQUE
#  index_media_channels_on_slug      (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Media::Channel, :type => :model do
  
  it "builds from factory", :internal do
    lambda { create(:media_channel) }.should_not raise_error
  end
  
  
end
