package ch.milosz.reactnative.event;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import ch.milosz.reactnative.ZoomConstants;

public class MeetingUserEvent extends BaseMeetingEvent {

  private final String userID;
  private String userName;
  private Boolean videoStatus;
  private Boolean audioStatus;
  private String videoRatio;
  private Boolean isHost;

  public MeetingUserEvent(@EventConstants String event, String userID) {
    super(event);
    this.userID = userID;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

  public void setVideoStatus(boolean videoStatus) {
    this.videoStatus = videoStatus;
  }

  public void setAudioStatus(boolean audioStatus) {
    this.audioStatus = audioStatus;
  }

  public void setVideoRatio(String videoRatio) {
    this.videoRatio = videoRatio;
  }

  public void setHost(boolean host) {
    isHost = host;
  }

  public WritableMap toParams() {
    WritableMap params = new WritableNativeMap();
    params.putString("event", event);
    params.putString(ZoomConstants.ARG_USER_ID, userID);
    params.putString(ZoomConstants.ARG_USER_NAME, userName);
    if (videoStatus != null) {
      params.putBoolean(ZoomConstants.ARG_VIDEO_STATUS, videoStatus);
    }
    if (audioStatus != null) {
      params.putBoolean(ZoomConstants.ARG_AUDIO_STATUS, audioStatus);
    }
    if (videoRatio != null) {
      params.putString(ZoomConstants.ARG_VIDEO_RATIO, videoRatio);
    }
    if (isHost != null) {
      params.putBoolean(ZoomConstants.ARG_IS_HOST, isHost);
    }
    return params;
  }
}
