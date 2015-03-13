require 'rails_helper'

RSpec.describe Study::Search, type:'model', elasticsearch: true do
  subject { build_stubbed(:study) }
    
  it_behaves_like 'it is Searchable', klass:Study
  
  describe 'Searching -', focus:true do
    before(:all) do
      @life_apps, @building_blocks, @wisdom = @studies = [
        
        create(:study, { # life_apps
          title:        'Life Apps', 
          description:  "Understanding Jesus' Life Platform, message by Lead Pastor Terry Brisbane with video application by Rusty Rueff."}),
        
        create(:study, { # building_blocks
          title:        'Building Blocks for a Sustainable Faith', 
          description:  "A Life of Progress message by Lead Pastor Terry Brisbane."}),
        
        create(:study, { # wisdom
          title:        'Wisdom for Living', 
          description:  "Paul's Prayer for the church at Colosse, Part 1"}),
      ]
    end
    
    index_models Study
    
    describe 'by title' do
      it 'finds exact matches' do
        expect(Study.search('Life Apps').records.to_a).to eq([@life_apps])
      end
      
      it 'finds matched words' do
        expect(Study.search('Life').records.to_a).to eq([@life_apps])
        expect(Study.search('Apps').records.to_a).to eq([@life_apps])
      end
      
      it 'finds partial matched words' do
        expect(Study.search('Lif').records.to_a).to eq([@life_apps])
        expect(Study.search('Sustaina').records.to_a).to eq([@building_blocks])
      end
      
      it 'ignores filler words' do
        expect(Study.search('for').records.to_a).to be_empty
      end
    end
    
    describe 'by description' do
      
    end
    
    # title partial match
    # description/body/etc phrase with partial after 1 word
    # keywords partial match
  end
end