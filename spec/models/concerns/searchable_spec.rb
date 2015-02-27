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

  it "enforces the #search_data interface" do
    lambda { DummyClass.new.search_data }.should raise_error(NotImplementedError)
  end

  it "enforces the #should_index? interface" do
    lambda { DummyClass.new.should_index? }.should raise_error(NotImplementedError)
  end
end


class DummyClass < ActiveRecord::Base
  has_no_table
  attr_accessor :title
  
  include Searchable
end