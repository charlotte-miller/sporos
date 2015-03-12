#DEPRECATED: moving these tests into _acts_searchable_shared

require 'rails_helper'

describe Searchable do
  subject { DummyClass.new }
  
  describe '#searchable_title( str )' do
    subject {DummyClass.new.send(:searchable_title, @original_str)}
    
    it 'defaults to #title' do
      instance = DummyClass.new
      instance.title = 'Foo Baz'
      expect(instance.bypass.searchable_title).to eq('foo baz')
    end
    
    it "downcases the str" do
      @original_str = "LOUD"
      should eql 'loud'
    end
    
    it "removes common leading words" do
      %w{a an and the for by}.each do |over_used|
        @original_str = over_used + ' glory and honor'
        should eql 'glory and honor'
      end
    end
  end

end


class DummyClass
  include Searchable
  attr_accessor :title
  
  # searchable_model
end