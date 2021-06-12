package ch.milosz.reactnative.event;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import us.zoom.sdk.MeetingStatus;

import static ch.milosz.reactnative.event.EventConstants.MEETING_STATE_CHANGE;

public class MeetingStateEvent {

  public static WritableMap toParams(MeetingStatus status) {
    WritableMap params = new WritableNativeMap();
    params.putString("event", MEETING_STATE_CHANGE);
    params.putInt("state", status.ordinal());
    params.putString("des", convertStatusToString(status));
    return params;
  }

  private static String convertStatusToString(MeetingStatus state) {
    switch (state) {
      case MEETING_STATUS_IDLE:
        return "no_meeting_running";
      case MEETING_STATUS_CONNECTING:
        return "connecting_meeting_server";
      case MEETING_STATUS_WAITINGFORHOST:
        return "waiting_host_start_meeting";
      case MEETING_STATUS_INMEETING:
        return "meeting_ready";
      case MEETING_STATUS_DISCONNECTING:
        return "disconnect_meeting_server";
      case MEETING_STATUS_RECONNECTING:
        return "reconnecting_meeting_server";
      case MEETING_STATUS_FAILED:
        return "failed_connect_meeting_server";
      case MEETING_STATUS_IN_WAITING_ROOM:
        return "in_waiting_room";
      case MEETING_STATUS_WEBINAR_PROMOTE:
        return "upgrade_attendees_panelist";
      case MEETING_STATUS_WEBINAR_DEPROMOTE:
        return "downgrade_attendees_panelist";
      case MEETING_STATUS_UNKNOWN:
        return "unknown_status";
      default:
        return "";
    }
  }
}
