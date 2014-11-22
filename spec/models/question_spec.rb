# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  admin_user_id :integer
#  source_id     :integer          not null
#  source_type   :string(255)      not null
#  text          :text(65535)
#  answers_count :integer          default("0")
#  blocked_count :integer          default("0")
#  stared_count  :integer          default("0")
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_questions_on_source_id_and_source_type       (source_id,source_type)
#  index_questions_on_stared_count_and_answers_count  (stared_count,answers_count)
#  index_questions_on_user_id                         (user_id)
#

require 'rails_helper'

describe Question do
  it { skip "should have_many  :answers"   } 
  it { should belong_to( :source             )}
  it { should belong_to( :author             )}
  it { should belong_to( :permanent_approver )}
  
  describe 'lesson' do
    context "source is a lesson" do
      it "should have a lesson" do
        skip
      end
    end
    
    context "source is a meeting" do
      it "should have a lesson through meeting" do
        skip
      end
    end
  end

  describe 'scopes' do
    describe 'meetings' do
      
    end
    
    describe 'lessons' do
      
    end
    
    describe 'groups' do
      
    end
    
  end
end
