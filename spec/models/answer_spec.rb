# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  question_id   :integer
#  author_id     :integer
#  text          :text(65535)
#  blocked_count :integer          default("0")
#  stared_count  :integer          default("0")
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_answers_on_author_id    (author_id)
#  index_answers_on_question_id  (question_id)
#

require 'rails_helper'

describe Answer do
  skip 'Add some tests'
end
