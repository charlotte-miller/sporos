module MeetingsHelper
  def current_meeting_status(meeting, current_meeting)
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
