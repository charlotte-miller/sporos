# == Schema Information
#
# Table name: posts
#
#  id                  :integer          not null, primary key
#  type                :text             not null
#  public_id           :string(21)       not null
#  parent_id           :integer
#  ministry_id         :integer          not null
#  user_id             :integer          not null
#  title               :text             not null
#  description         :text
#  display_options     :jsonb            default("{}"), not null
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  poster_original_url :string
#  rejected_at         :datetime
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  featured_at         :datetime
#
# Indexes
#
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_public_id    (public_id) UNIQUE
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

require 'rails_helper'

RSpec.describe Posts::Event, :type => :model do
  subject { create :post_event }
  
  describe '[before_validate] #set_expired_at' do
    it 'sets a missing expired_at to the event start-time' do
      event = create :post_event, expired_at:nil, event_time:Time.parse("10:00 AM"), event_date:in_two_weeks = Date.today+2.weeks
      expect(event.expired_at).to_not be_nil
      expect(event.expired_at.to_date).to eql in_two_weeks
      expect(event.expired_at.hour).to eql 10
    end
    
    it 'does nothing if expired_at set' do
      event = create(:post_event, {
        expired_at: Time.now + 1.week,
        event_time:Time.parse("10:00 AM"), 
        event_date:in_two_weeks = Date.today+2.weeks
      })
      expect(event.expired_at).to_not be_nil
      expect(event.expired_at.to_date).to_not eql in_two_weeks      
    end
  end
  
  describe '#combined_event_time_obj' do
    it 'returns a Time obj' do
      expect(subject.combined_event_time_obj).to be_a Time
    end
    
    it 'returns the correct date and time' do
      event = create( :post_event, event_time:Time.parse("11:00 AM"), event_date:in_two_weeks = Date.today+2.weeks)
      expect(event.combined_event_time_obj.hour).to eq(11)
      expect(event.combined_event_time_obj.to_date).to eq(in_two_weeks)
    end
  end
  
end
