require 'rails_helper'

describe Podcast::Collector do

  describe '.new' do
    before(:each) do
      @podcasts = 2.times.map { create(:podcast) }
      @podcast  = Podcast.first
    end

    it "queues requests for the collection of Podcasts" do
      q = Podcast::Collector.new([@podcast]).queue
      expect(q.length).to be(1)
      q.each do |item|
        expect(item).to be_an_instance_of Typhoeus::Request
        expect(item.base_url).to eql @podcast.url
      end
    end

    it "requires an array of @podcasts" do
      expect(lambda { Podcast::Collector.new(@podcast)         }).to raise_error(ArgumentError)
      expect(lambda { Podcast::Collector.new(['not podcast'])  }).to raise_error(ArgumentError)
      expect(lambda { Podcast::Collector.new([@podcast])       }).to_not raise_error
    end
  end

  describe '#run!' do
    before(:each) do
      @podcasts    = 2.times.map { p = create(:podcast) }
      @podcast_xml = File.read(File.join(Rails.root, 'spec/files/podcast_xml', 'itunes.xml'))
      stub_request(:get, %r{/podcasts/audio_podcast.xml$}).to_return( :body => @podcast_xml, :status => 200 )
    end

    it "calls &on_complete for each @podcast" do
      @podcasts.each {|p| def p.foo xml; end} #stub w/out verify_partial_doubles
      @podcasts.each {|podcast| podcast.should_receive(:foo).once.with(@podcast_xml) }
      collector = Podcast::Collector.new(@podcasts) {|podcast_obj, podcast_xml| podcast_obj.foo(podcast_xml) }
      collector.run!
    end
  end

end
