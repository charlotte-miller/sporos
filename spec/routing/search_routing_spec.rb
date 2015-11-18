require "spec_helper"

describe SearchController do
  describe "routing" do

    it "routes to #index" do
      get("/search").should route_to("search#index")
    end

    it "routes to #preload" do
      get("/search/preload").should route_to("search#preload")
    end

  end
end
