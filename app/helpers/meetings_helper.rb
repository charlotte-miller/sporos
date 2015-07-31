module MeetingsHelper
  def current_meeting_status(meeting, current_lesson)
    if meeting.position < current_lesson.position
      "past"
    elsif meeting.position == current_lesson.position
      "current"
    elsif meeting.position > current_lesson.position
      "future"
    end
  end
end
