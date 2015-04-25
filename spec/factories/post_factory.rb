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
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_public_id    (public_id) UNIQUE
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

FactoryGirl.define do
  factory :post, class:'Posts::Link' do
    before(:create, :stub) { AWS.stub! if Rails.env.test? }
    # after(:build) {|post, context| post.class.skip_callback(:create, :after, :request_approval!) }
    
    type            'Posts::Link'
    ministry
    author          { FactoryGirl.create(:involvement, ministry:ministry).user }
    title           { Faker::Lorem.sentence(rand(3..8))  }
    description     { Faker::Lorem.paragraph(rand(2..5)) }
    display_options { {} }
    poster { fixture_file_upload(Rails.root.join('spec/files/', 'poster_image.jpg'), 'image/jpg', true) }
    published_at nil
    expired_at   nil
    
    # factory :post_w_approval_requests do
    #   after(:create) {|post, context| post.send(:request_approval!)}
    # end
  end
  
  factory :published_post, parent:'post' do
    published_at {Time.now - 1.minute}
  end
  
  factory :post_event, parent:'post', class:'Posts::Event' do
    expired_at {Time.now + 2.weeks}
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
