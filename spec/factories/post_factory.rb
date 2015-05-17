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
    rejected_at  nil
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
    ignore do
      event_time { Time.parse("10:00 AM") }
      event_date { Date.today+2.weeks }
    end
    
    type       'Posts::Event'
    display_options {{event_time:event_time.strftime('%l:%M %p'), event_date:event_date.strftime('%d %b, %Y')}}
    expired_at {Time.now + 2.weeks}
  end

  factory :post_link, parent:'post', class:'Posts::Link' do
    type 'Posts::Link'
  end

  factory :post_page, parent:'post', class:'Posts::Page' do
    type 'Posts::Page'
  end
  
  factory :post_photo, parent:'post', class:'Posts::Photo' do
    type 'Posts::Photo'
  end
  
  factory :post_video, parent:'post', class:'Posts::Video' do
    ignore do
      vimeo_id '124184882'
    end
    
    type 'Posts::Video'
    display_options { {vimeo_id: vimeo_id} }
  end
  
end
