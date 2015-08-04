require 'rails_helper'

RSpec.describe Page::Search, :type => :model, elasticsearch: true do
  subject { build_stubbed(:page) }

  it_behaves_like 'it is Searchable', klass:Page

  describe 'Searching By:' do
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

    import_models Page



    describe 'title' do
      it 'finds exact matches' do
        expect(Page.search('title:Children').records.to_a).to eq([@children])
      end

      it 'finds matched words' do
        expect(Page.search('title:About').records.to_a).to eq([@about_us])
        expect(Page.search('title:Us').records.to_a).to eq([@about_us])
      end

      it 'finds partial matched words' do
        pending
        expect(Page.search('title:Chil').records.to_a).to eq([@children])
        expect(Page.search('title:Abou').records.to_a).to eq([@about_us])
      end

      it 'ignores filler words' do
        expect(Page.search('title:for').records.to_a).to be_empty
      end
    end

    describe 'display_description' do
      # phrase with partial after 1 word
    end

    describe 'body' do
      # strip html
    end

    describe 'seo_keywords' do
      # partial match
    end
  end

end
