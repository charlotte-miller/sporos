module GroupsHelper
  def current_meeting_from(group)
    group.meetings.detect { |m| m.date_of > Time.now }
  end

  def current_meeting_position(meeting, current_meeting)
    return "finished" if current_meeting.blank?
    if meeting.position < current_meeting.position
      "past"
    elsif meeting.position == current_meeting.position
      "current"
    elsif meeting.position > current_meeting.position
      "future"
    end
  end

  def percent_completed(user_lesson_state, lesson)
    if lesson.duration.present?
      user_lesson_state.media_progress.to_f/lesson.duration.to_f * 100.0
    else
      0.0
    end
  end

end
