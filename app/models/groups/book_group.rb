# == Schema Information
#
# Table name: groups
#
#  id                      :integer          not null, primary key
#  state                   :string(50)       not null
#  name                    :string           not null
#  description             :text             not null
#  is_public               :boolean          default("true")
#  meets_every_days        :integer          default("7")
#  meetings_count          :integer          default("0")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :text             not null
#  study_id                :integer
#  approved_at             :datetime
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  study_group_data        :jsonb            default("{}"), not null
#  book_group_data         :jsonb            default("{}"), not null
#  affinity_group_data     :jsonb            default("{}"), not null
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#  index_groups_on_study_id             (study_id)
#  index_groups_on_type_and_id          (type,id)
#

class Groups::BookGroup < Group
  delegate_attrs_to_jsonb :purchase_link,
    to: :book_group_data
end
