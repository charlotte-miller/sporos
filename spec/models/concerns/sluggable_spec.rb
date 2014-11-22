require 'rails_helper'

describe Sluggable do
  subject { SluggableDummyClass.new }
  
  describe 'FriendlyId integration' do
    it "responds_to friendly_id" do
      expect(SluggableDummyClass).to respond_to :friendly_id
    end
  end
  
  describe '.slug_candidates' do
    it "defines #slug_candidates AND return the arguments as an array" do
      is_expected.to respond_to :slug_candidates
      expect(subject.slug_candidates).to eq [:title, [:title, :year], [:title, :month, :year]]
    end
  end
  
  describe 'Canidate Helpers' do  
    describe '#year' do
      it 'returns the created_at year' do
        subject.created_at = Date.parse('12/12/2012')
        expect(subject.year).to eq 2012
      end
      
      it 'returns the current year IF created_at is nil' do
        Timecop.travel('11/11/2011') do
          expect(subject.year).to eq 2011
        end
      end
    end
    
    describe '#month' do
      it 'returns the created_at month' do
        subject.created_at = Date.parse('12/12/2012')
        expect(subject.month).to eq 'December'
      end
      
      it 'returns the current month IF created_at is nil' do
        Timecop.travel('11/11/2011') do
          expect(subject.month).to eq 'November'
        end
      end
    end
    
    describe '#date' do
      it 'returns the created_at date' do
        subject.created_at = Date.parse('12/12/2012')
        expect(subject.date).to eq 12
      end
      
      it 'returns the current date IF created_at is nil' do
        Timecop.travel('11/11/2011') do
          expect(subject.date).to eq 11
        end
      end
    end
  end
end

 
class SluggableDummyClass < ActiveRecord::Base
  has_no_table
  attr_accessor :created_at
  
  include Sluggable
  slug_candidates :title, [:title, :year], [:title, :month, :year]
end