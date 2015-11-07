require 'rails_helper'

RSpec.describe SearchController, :focus, :type => :controller do

  describe "GET index", :elasticsearch do
    let(:stub_search) { Elasticsearch::Model.client.stub :search }

    it 'requires params[:q]' do
      stub_search
      expect(lambda {get :index}).to raise_error(ActionController::ParameterMissing)
      expect(lambda {get :index, {q:'foo'}}).not_to raise_error
    end

    describe 'RESULTS SCHEMA' do
      let(:results) { DeepStruct.new( get( :index, {q:'foo'} ) && assigns(:results)) }
      let(:hit) { results.hits.hits.first }
      before(:all) { create(:page, title:'Foo is How We Do') }
      import_models Page

      it 'returns JSON' do
        get :index, {q:'foo'}
        expect(response).to have_http_status(:success)
        expect(lambda{MultiJson.load(response.body)}).not_to raise_error
      end

      describe '.hits' do
        %w{_type _id _score _source highlight}.each do |required_interface|
          it "has a #{required_interface}" do
            expect(hit[required_interface]).not_to be_nil
          end
        end

        describe '._source' do
          %w{title preview path}.each do |required_interface|
            it "has a #{required_interface}" do
              expect(hit['_source'][required_interface]).not_to be_nil
            end
          end
        end
      end

      describe '.aggregations.type_counts' do
        it 'provides counts of each type' do
          sample_count = results.aggregations.type_counts.buckets.first
          expect(sample_count['key']).to eq('page')
          expect(sample_count['doc_count']).to eq(1)
        end
      end
    end

    describe 'RESULTS' do
      before(:all) do
        @children, @about_us, @volunteer = @pages = [
          create(:page, { # children
            title:        'Children',
            body:         "<h2>Sign up for the Children's Ministry Newsletter</h2>"}),

          create(:page, { # about_us
            title:        'About Us',
            body:         '<p><img src="{{ MEDIA_URL }}/uploads/generic/PT_speaking.jpg"><br/><blockquote><h2>Our Mission:</h2><p>To be an exceptional outreach church that establishes people<br/>as committed followers of Jesus Christ</p></blockquote></p>'}),

          create(:page, { # wisdom
            title:        'Volunteer Appreciation Dinner',
            body:         '<img src="{{ MEDIA_URL }}/uploads/generic/volunteerDinner_logotype_1.png"><br/><br/><h2>Friday, October 17 • 6:30pm-8:30pm<br/>Lake Merced Campus</h2>'}),
        ]
      end
      # import_models Page, Study, Lesson
    end

  end

end
