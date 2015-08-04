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

FactoryGirl.define do
  factory :ministry do
    name {Faker::Lorem.words(3).split('').shuffle.join('').titlecase }
    description { "#{name.titlecase}'s Ministry is for #{name.downcase.pluralize}... coffee will be served." }
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

    before(:create) do |ministry, context|
      Involvement.levels.values.each do |level_index|
        2.times do
          ministry.involvements << FactoryGirl.create(:involvement, { level:level_index })
        end
      end
      ministry.save!
    end
  end

end
