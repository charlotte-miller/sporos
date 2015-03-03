require 'rails_helper'

RSpec.describe Page::Search, :type => :model, elasticsearch: true, focus:true do
  before(:each) { Page.__elasticsearch__.create_index!(force: true) }
  after(:each)  { Page.__elasticsearch__.create_index!(force: true) }
  
  subject { build(:page) }
  
  describe '.import' do
    before(:all) do
      @pages = 3.times.map { create(:page) }
    end
    
    it 'imports successfully' do
      expect( lambda {Page.import}).not_to raise_error
      wait_for_success(3) { Page.search('*').present? }
      expect(Page.search('*').records.to_a).to eq(@pages)
    end
  end
  
  # =====================================================
  # = Consider what can be abstracted from study search =
  # =====================================================
  # maybe behaves_like a_searchable_model
  
end