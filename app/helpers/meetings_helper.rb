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
end
