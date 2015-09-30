# == Schema Information
#
# Table name: faqs
#
#  id            :integer          not null, primary key
#  faq_answer_id :integer
#  body          :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_faqs_on_faq_answer_id  (faq_answer_id)
#

require 'rails_helper'

RSpec.describe Faq, :type => :model do
  it "builds from factory", :internal do
    expect { create(:faq) }.to_not raise_error
  end
end
