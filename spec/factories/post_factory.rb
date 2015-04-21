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
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_expired_at   (expired_at)
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

FactoryGirl.define do
  factory :post, class:'Posts::Link' do
    before(:create, :stub) { AWS.stub! if Rails.env.test? }
    # after(:build) {|post, context| post.class.skip_callback(:create, :after, :request_approval!) }
    
    ministry
    author          { FactoryGirl.create(:involvement, ministry:ministry).user }
    title           { Faker::Lorem.sentence(rand(3..8))  }
    description     { Faker::Lorem.paragraph(rand(2..5)) }
    display_options { {} }
    poster { fixture_file_upload(Rails.root.join('spec/files/', 'poster_image.jpg'), 'image/jpg', true) }
    published_at nil
    expired_at {Time.now + 3.days}
    
    # factory :post_w_approval_requests do
    #   after(:create) {|post, context| post.send(:request_approval!)}
    # end
  end
  
  factory :post_event, parent:'post', class:'Posts::Event' do
  end

  factory :post_link, parent:'post', class:'Posts::Link' do
  end

  factory :post_page, parent:'post', class:'Posts::Page' do
  end
  
  factory :post_photo, parent:'post', class:'Posts::Photo' do
  end
  
  factory :post_video, parent:'post', class:'Posts::Video' do
  end
  
end
