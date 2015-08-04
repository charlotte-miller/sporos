require "spec_helper"

describe SearchController do
  describe "routing" do

    it "routes to #index" do
      get("/search").should route_to("search#index")
    end

    it "routes to #conversion" do
      post("/search/conversion").should route_to("search#conversion")
    end

    it "routes to #abandonment" do
      post("/search/abandonment").should route_to("search#abandonment")
    end

  end
end
