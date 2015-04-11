# == Schema Information
#
# Table name: posts
#
#  id                  :integer          not null, primary key
#  parent_id           :integer
#  type                :text             not null
#  ministry_id         :integer          not null
#  title               :text             not null
#  description         :text
#  display_options     :hstore
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  expires_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_type         (type)
#

class Post < ActiveRecord::Base
  include Sanitizable
  include AttachableFile

  # ---------------------------------------------------------------------------------
  # Single Table Inheritance
  # ---------------------------------------------------------------------------------  
  scope :events,  -> { where(type: 'Post::Event') }
  scope :link,    -> { where(type: 'Post::Link') }
  scope :page,    -> { where(type: 'Post::Page') }
  scope :photo,   -> { where(type: 'Post::Photo') }
  scope :video,   -> { where(type: 'Post::Video') }


  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------  
  belongs_to :ministry
  
  has_many :approvals
  has_one :draft, :class_name => "Post", :foreign_key => "parent_id"
  
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  has_attachable_file :poster, {
                      # :processors      => [:thumbnail, :pngquant],
                      :default_style => :sd,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      # production_path: 'studies/lesson_media/:study_id/:hash:quiet_style.:extension',
                      :styles => {
                        sd:     { format: 'png', convert_options: "-strip" },
                        hd:     { format: 'png', convert_options: "-strip" },
                        mobile: { format: 'png', convert_options: "-strip" }}}
  
end
