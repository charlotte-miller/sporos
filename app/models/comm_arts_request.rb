# == Schema Information
#
# Table name: comm_arts_requests
#
#  id                    :integer          not null, primary key
#  post_id               :integer
#  design_requested      :boolean
#  design_creative_brief :jsonb            default("{}"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  due_date              :datetime
#  archived_at           :datetime
#  todo                  :jsonb
#  print_quantity        :jsonb
#
# Indexes
#
#  index_comm_arts_requests_on_archived_at  (archived_at)
#  index_comm_arts_requests_on_post_id      (post_id)
#

class CommArtsRequest < ActiveRecord::Base
  belongs_to :post
  has_one :ministry, through: :post
  has_one :author, through: :post

  delegate_attrs_to_jsonb :design_purpose,
    :design_tone,
    :design_cta,
    :notes,
    to: :design_creative_brief

  delegate_attrs_to_jsonb :title, :ministry_id, :author_id,
    to: :todo

  delegate_attrs_to_jsonb(
    :postcard_quantity,
    :poster_quantity,
    :booklet_quantity,
    :badges_quantity,
    to: :print_quantity)

  attr_protected #none

  def ministry_with_fallback
    if ministry.present?
      ministry
    elsif ministry_id.present?
      Ministry.find(ministry_id)
    end
  end

  def user_with_fallback
    if post.present?
      post.author
    elsif author_id.present?
      User.find(author_id)
    end
  end

  def title_with_fallback
    post.present? ? post.title : title
  end

end
