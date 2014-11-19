# == Schema Information
#
# Table name: churches
#
#  id         :integer          not null, primary key
#  name       :string(100)      not null
#  homepage   :string(100)      not null
#  created_at :datetime
#  updated_at :datetime
#

require 'active_support'
FactoryGirl.define do
  factory :church do
    name "Cornerstone Church"
    homepage {|c| "http://#{c.name.gsub(/\s/,'').underscore.dasherize}.com"}
  end
end
