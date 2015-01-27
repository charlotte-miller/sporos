# == Schema Information
#
# Table name: podcasts
#
#  id           :integer          not null, primary key
#  church_id    :integer          not null
#  title        :string(100)
#  url          :string(255)      not null
#  last_checked :datetime
#  last_updated :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Media::Lesson::Adapters::Podcast do
  before(:all) { @podcast_xml = File.read(File.join(Rails.root, 'spec/files/podcast_xml', 'itunes.xml')) }
  let(:channel) { Podcast::Channel.new(@podcast_xml) }
  let(:podcast_item) { channel.items.first }
  subject { Media::Lesson::Adapters::Podcast.new podcast_item }

  it "builds from a Podcast::Item" do
    podcast_item.should be_an_instance_of Podcast::Item
    subject.should be_an_instance_of Media::Lesson::Adapters::Podcast
  end

  it "assigns data to every attribute in the interface" do
    Media::Lesson::Adapters::Base::ATTRIBUTES.each do |attr|
      subject.send(attr).should_not be_nil
    end
  end
end
