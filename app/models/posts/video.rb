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

class Posts::Video < Post
  delegate :vimeo_id, to: :display_options
  
  validate :did_upload_video
  
  def vimeo_id=(id)
    self.display_options= display_options.to_h.merge({vimeo_id:id})
  end
  
  before_save :update_vimeo_details
  
  def update_vimeo_details
    if new_record? || display_options_changed?
      VimeoCreateTicket.new(:skip_ticket).update_video_metadata vimeo_id, {
        title:title,
        description:description
      }
    end
  end
  
  def did_upload_video
    unless vimeo_id.present?
      errors.add(:base, 'Missing Video')
    end
  end
end
