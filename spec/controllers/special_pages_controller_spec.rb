require 'rails_helper'

RSpec.describe SpecialPagesController, :type => :controller do

  describe "GET 'new_to_cornerstone'" do
    it "returns http success" do
      get 'new_to_cornerstone'
      expect(response).to be_success
    end
  end

  describe "GET 'times_and_locations'" do
    it "returns http success" do
      get 'times_and_locations'
      expect(response).to be_success
    end
  end

  describe "GET 'invest_in_cornerstone'" do
    it "returns http success" do
      get 'invest_in_cornerstone'
      expect(response).to be_success
    end
  end

end
