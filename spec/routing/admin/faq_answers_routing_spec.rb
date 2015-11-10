require "rails_helper"

RSpec.describe Admin::FaqAnswersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/faq_answers").to route_to("admin/faq_answers#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/faq_answers/new").to route_to("admin/faq_answers#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/faq_answers/1").to route_to("admin/faq_answers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/faq_answers/1/edit").to route_to("admin/faq_answers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/faq_answers").to route_to("admin/faq_answers#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/faq_answers/1").to route_to("admin/faq_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/faq_answers/1").to route_to("admin/faq_answers#destroy", :id => "1")
    end

  end
end
