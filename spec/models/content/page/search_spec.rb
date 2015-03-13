require 'rails_helper'

RSpec.describe Page::Search, :type => :model, elasticsearch: true do
  subject { build_stubbed(:page) }
  
  it_behaves_like 'it is Searchable', klass:Page
  
  describe 'Searching By:' do
    before(:all) do
      @pages = 3.times.map { create(:page) }
    end
    
    index_models Page
    
    
  end
  
end