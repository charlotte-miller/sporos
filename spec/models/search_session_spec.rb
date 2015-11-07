# == Schema Information
#
# Table name: searchjoy_searches
#
#  id               :integer          not null, primary key
#  rails_session_id :text
#  ui_session_data  :jsonb            default("{}"), not null
#  search_type      :text
#  query            :text
#  normalized_query :text
#  results_count    :integer
#  created_at       :datetime
#  updated_at       :datetime
#  convertable_id   :integer
#  convertable_type :text
#  converted_at     :datetime
#
# Indexes
#
#  index_searchjoy_searches_on_convertable_id_and_convertable_type  (convertable_id,convertable_type)
#  index_searchjoy_searches_on_created_at                           (created_at)
#  index_searchjoy_searches_on_rails_session_id                     (rails_session_id)
#  index_searchjoy_searches_on_search_type_and_created_at           (search_type,created_at)
#  index_searchjoy_searches_on_search_type_and_normalized_query_an  (search_type,normalized_query,created_at)
#

require 'rails_helper'

RSpec.describe SearchSession, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"

  # describe 'POST conversion' do
  #
  # end
  #
  # describe 'POST abandonment' do
  #   let(:run) { post :abandonment, {current_search:'food', result_count:12} }
  #
  #   it 'creates an Faq from the abandoned search' do
  #
  #   end
  #
  #   it "stores the sender's email" do
  #
  #   end
  # end

end
