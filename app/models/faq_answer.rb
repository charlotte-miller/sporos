# == Schema Information
#
# Table name: faq_answers
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  body           :text
#  more_info_path :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_faq_answers_on_user_id  (user_id)
#

class FaqAnswer < ActiveRecord::Base
  # attr_accessor :question_variants

  belongs_to :author, :class_name => "User", :foreign_key => "user_id"

  has_many :questions, class_name: "Faq", dependent: :nullify
  accepts_nested_attributes_for :questions

  def build_questions_for(array_of_strings)
    self.questions_attributes = array_of_strings.map {|q| {body:q} }
    self
  end
end
