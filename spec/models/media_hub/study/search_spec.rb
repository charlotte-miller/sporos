require 'rails_helper'

RSpec.describe Study::Search, type:'model', elasticsearch: true, focus:true do
  subject { build(:study) }
  before(:all) do
    @studies = 3.times.map { create(:study) }
  end
  
  describe '.import' do
    before(:each) { Study.__elasticsearch__.create_index!(force: true) }
    after(:each)  { Study.__elasticsearch__.create_index!(force: true) }
    
    it 'imports successfully' do
      expect( lambda {Study.import}).not_to raise_error
      wait_for_success(3) { Study.search('*').present? }
      expect(Study.search('*').records.to_a).to eq(@studies)
    end
  end
  
  describe '[indexed data]' do
    index_model Search
    
    describe '#as_indexed_json(options={})' do
      it 'needs tests' do
        
      end
    end
  end
end