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
#  index_ministries_on_name      (name) UNIQUE
#  index_ministries_on_url_path  (url_path) UNIQUE
#

FactoryGirl.define do
  factory :ministry do      
    name {Faker::Lorem.word.titlecase}
    description { "#{name.titlecase}'s Ministry is for #{name.downcase.pluralize}... coffee will be served." }
    url_path { "/#{name.downcase}" }
  end
  
  factory :ministry_w_member, parent:'ministry' do
    ignore do
      user nil
      involvement_level nil
    end
    
    after(:create) do |ministry, context|
      options = { ministry: ministry }
      options.merge!({level: context.involvement_level}) if context.involvement_level
      options.merge!({user: context.user}) if context.user
      
      FactoryGirl.create(:involvement, options)
    end
  end
  
  factory :populated_ministry, parent:'ministry' do
    ignore do
      n 2
    end
    
    after(:create) do |ministry, context|
      Involvement.levels.each do |level|
        2.times do
          FactoryGirl.create(:involvement, { ministry: ministry, level:level.last })
        end
      end
    end
  end

end
