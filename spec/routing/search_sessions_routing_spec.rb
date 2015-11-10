require "rails_helper"

RSpec.describe SearchSessionsController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/search_sessions/1").to route_to("search_sessions#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/search_sessions").to route_to("search_sessions#create")
    end

    it "routes to #update" do
      expect(:put => "/search_sessions/1").to route_to("search_sessions#update", :id => "1")
    end

  end
end
