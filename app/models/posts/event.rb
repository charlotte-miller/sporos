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

class Posts::Event < Post
  delegate :location, :event_time, :event_date, to: :display_options

  before_validation :set_expired_at
  validates_presence_of :event_time, :event_date, :location, :description
  validate :expires_at_or_before_the_event

  def set_expired_at
    self.expired_at ||= combined_event_time_obj
  end

  def combined_event_time_obj
    return unless (event_time.present? || event_date.present?)
    Time.parse("#{event_date} #{event_time}")
  end

  def expires_at_or_before_the_event
    return unless expired_at.present?

    if expired_at > combined_event_time_obj
      errors.add(:expired_at, 'cannot be AFTER the event.')
      # self.errors.add_to_base("")
    end
  end

end
