package ch.milosz.reactnative.event;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

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
    params.putString("userID", userID);
    params.putString("userName", userName);
    if (videoStatus != null) {
      params.putBoolean("videoStatus", videoStatus);
    }
    if (audioStatus != null) {
      params.putBoolean("audioStatus", audioStatus);
    }
    if (videoRatio != null) {
      params.putString("videoRatio", videoRatio);
    }
    if (isHost != null) {
      params.putBoolean("isHost", isHost);
    }
    return params;
  }
}
