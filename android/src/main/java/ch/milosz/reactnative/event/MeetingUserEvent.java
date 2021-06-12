package ch.milosz.reactnative.event;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import us.zoom.sdk.InMeetingUserInfo;

import static ch.milosz.reactnative.ZoomConstants.ARG_AUDIO_STATUS;
import static ch.milosz.reactnative.ZoomConstants.ARG_IS_HOST;
import static ch.milosz.reactnative.ZoomConstants.ARG_SHARE_STATUS;
import static ch.milosz.reactnative.ZoomConstants.ARG_USER_ID;
import static ch.milosz.reactnative.ZoomConstants.ARG_USER_NAME;
import static ch.milosz.reactnative.ZoomConstants.ARG_VIDEO_RATIO;
import static ch.milosz.reactnative.ZoomConstants.ARG_VIDEO_STATUS;

public class MeetingUserEvent {

  public static WritableMap toParams(@EventConstants String event, InMeetingUserInfo info) {
    return toParams(event, info, null);
  }

  public static WritableMap toParams(@EventConstants String event, InMeetingUserInfo info, Integer shareStatus) {
    WritableMap params = new WritableNativeMap();
    params.putString("event", event);
    params.putString(ARG_USER_ID, String.valueOf(info.getUserId()));
    params.putString(ARG_USER_NAME, info.getUserName());
    params.putString(ARG_VIDEO_RATIO, "1.0");
    params.putBoolean(ARG_VIDEO_STATUS, info.getVideoStatus() != null && info.getVideoStatus().isSending());
    params.putBoolean(ARG_AUDIO_STATUS, info.getAudioStatus() != null && !info.getAudioStatus().isMuted());
    params.putBoolean(ARG_IS_HOST, info.getInMeetingUserRole() == InMeetingUserInfo.InMeetingUserRole.USERROLE_HOST);
    if (shareStatus != null) {
      params.putInt(ARG_SHARE_STATUS, shareStatus);
    }
    return params;
  }
}
