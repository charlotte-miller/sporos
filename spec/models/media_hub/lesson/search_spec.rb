require 'rails_helper'

RSpec.describe Lesson::Search, :type => :model, elasticsearch: true do
  subject { build_stubbed(:lesson) }
  
  it_behaves_like 'it is Searchable', klass:Page
  
  describe 'Search By:' do
    before(:all) do
      @lessons = 3.times.map { create(:lesson) }
    end
    
    index_models Lesson
    
    
  end
end