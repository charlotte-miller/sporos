require 'rails_helper'

RSpec.describe "Admin::FaqAnswers", :type => :request do
  describe "GET /admin_faq_answers" do
    it "works! (now write some real specs)" do
      get admin_faq_answers_path
      expect(response).to have_http_status(200)
    end
  end
end
