require "rails_helper"

RSpec.describe Admin::MinistriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/ministries").to route_to("admin/ministries#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/ministries/new").to route_to("admin/ministries#new")
    end

    it "DOES NOT routes to #show" do
      expect(:get => "/admin/ministries/1").not_to route_to("admin/ministries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/ministries/1/edit").to route_to("admin/ministries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/ministries").to route_to("admin/ministries#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/ministries/1").to route_to("admin/ministries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/ministries/1").to route_to("admin/ministries#destroy", :id => "1")
    end

  end
end
