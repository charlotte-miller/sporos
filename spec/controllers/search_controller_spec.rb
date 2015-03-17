require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  describe "GET index", skip:true do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  
  describe 'RESPONSE SCHEMA' do
    describe '.hits[n]._source' do
      
    end
    
    describe '.hits[n].highlight' do
      
    end
    
    describe '.aggregations.type_counts' do
      #test facets
    end
  end
  

end
