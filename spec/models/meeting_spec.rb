# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null
#  lesson_id  :integer          not null
#  position   :integer          default("0"), not null
#  state      :string(50)       not null
#  date_of    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_meetings_on_group_id_and_position  (group_id,position)
#  index_meetings_on_group_id_and_state     (group_id,state)
#  index_meetings_on_lesson_id              (lesson_id)
#

require 'rails_helper'

describe Meeting do
  it { should belong_to :group  }
  it { should belong_to :lesson }
  
  it "builds from factory", :internal do
    lambda { create(:meeting) }.should_not raise_error
  end
  
  it_behaves_like 'it is Sortable', scoped_to:'group'
end
