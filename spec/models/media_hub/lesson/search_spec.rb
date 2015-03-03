require 'rails_helper'

RSpec.describe Lesson::Search, :type => :model, elasticsearch: true, focus:true do
  before(:each) { Lesson.__elasticsearch__.create_index!(force: true) }
  after(:each)  { Lesson.__elasticsearch__.create_index!(force: true) }
  
  subject { build(:lesson) }
  
  describe '.import' do
    before(:all) do
      @lessons = 3.times.map { create(:lesson) }
    end
    
    it 'imports successfully' do
      expect( lambda {Lesson.import}).not_to raise_error
      wait_for_success(3) { Lesson.search('*').present? }
      expect(Lesson.search('*').records.to_a).to eq(@lessons)
    end
  end
  
  # =====================================================
  # = Consider what can be abstracted from study search =
  # =====================================================
  # maybe behaves_like a_searchable_model
end