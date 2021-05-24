package ch.milosz.reactnative.event;

public @interface EventConstants {
  String MEETING_STATE_CHANGE = "meetingStateChange";
  String MEETING_USER_JOIN = "sinkMeetingUserJoin";
  String MEETING_USER_LEFT = "sinkMeetingUserLeft";
  String MEETING_AUDIO_STATUS_CHANGE = "onSinkMeetingAudioStatusChange";
  String MEETING_VIDEO_STATUS_CHANGE = "onSinkMeetingVideoStatusChange";
}
