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

class Posts::Photo < Post
  after_validation :assign_poster

  validate :did_upload_images

  def assign_poster
    self.poster= uploaded_files.last.try(:file) unless poster.present?
  end

  def did_upload_images
    unless uploaded_files.count > 0 || (current_session && UploadedFile.where(session_id:current_session).count > 0)
      errors.add(:base, 'You must upload pictures')
    end
  end
end
