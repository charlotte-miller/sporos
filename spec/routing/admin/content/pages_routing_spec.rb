require "rails_helper"

RSpec.describe Admin::Content::PagesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/content/pages").to route_to("admin/content/pages#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/content/pages/new").to route_to("admin/content/pages#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/content/pages/1").to route_to("admin/content/pages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/content/pages/1/edit").to route_to("admin/content/pages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/content/pages").to route_to("admin/content/pages#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/content/pages/1").to route_to("admin/content/pages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/content/pages/1").to route_to("admin/content/pages#destroy", :id => "1")
    end

  end
end
