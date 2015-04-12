# == Schema Information
#
# Table name: posts
#
#  id                  :integer          not null, primary key
#  parent_id           :integer
#  type                :text             not null
#  ministry_id         :integer          not null
#  user_id             :integer          not null
#  title               :text             not null
#  description         :text
#  display_options     :hstore
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  published_at        :datetime
#  expires_at          :datetime         not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

require 'rails_helper'

RSpec.describe Post, :type => :model do
  subject { build(:post) }

  it "builds from factory", :internal do
    [:post, :post_event, :post_link, :post_page, :post_photo, :post_video].each do |factory|
      expect { create(factory) }.to_not raise_error
    end
  end
  
  it { should belong_to(:ministry) }
  it { should have_many(:approval_requests) }
  it { should have_one(:draft) }
  
  describe '#update_status!' do
    before(:all) do
      
    end
    
  end
end
