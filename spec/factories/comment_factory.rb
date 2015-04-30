# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  title            :string
#  body             :text
#  user_id          :integer          not null
#  parent_id        :integer
#  lft              :integer          not null
#  rgt              :integer          not null
#  depth            :integer          default("0"), not null
#  children_count   :integer          default("0"), not null
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_depth                                (depth)
#  index_comments_on_lft                                  (lft)
#  index_comments_on_parent_id                            (parent_id)
#  index_comments_on_rgt                                  (rgt)
#  index_comments_on_user_id                              (user_id)
#

FactoryGirl.define do
  factory :comment do
    commentable { FactoryGirl.create(:post)          }
    title       { Faker::Lorem.sentence(rand(3..8))  }
    body        { Faker::Lorem.paragraph(rand(2..5)) }
    user
    parent nil
    
  end
end
