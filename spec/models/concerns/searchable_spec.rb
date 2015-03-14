#DEPRECATED: moving these tests into _acts_searchable_shared

require 'rails_helper'

describe Searchable do
  subject { DummyClass.new }
  
  
end


class DummyClass
  include Searchable
  attr_accessor :title
  
  # searchable_model
end