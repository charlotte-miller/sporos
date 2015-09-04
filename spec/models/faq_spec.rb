# == Schema Information
#
# Table name: faqs
#
#  id                :integer          not null, primary key
#  question_variants :text             default("{}"), is an Array
#  answer            :text             not null
#  more_info_path    :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Faq, :type => :model do
  it "builds from factory", :internal do
    expect { create(:faq) }.to_not raise_error
  end
end
