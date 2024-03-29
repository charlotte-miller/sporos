# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  question_id   :integer
#  author_id     :integer
#  text          :text
#  blocked_count :integer          default("0")
#  stared_count  :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_answers_on_author_id    (author_id)
#  index_answers_on_question_id  (question_id)
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :author, class_name: 'User'
  attr_accessible :text

  validates_presence_of :question_id, :author_id, :text
end
