package ch.milosz.reactnative;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.widget.PopupWindow;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.modules.core.PermissionListener;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicBoolean;

import ch.milosz.reactnative.audio.MeetingAudioCallback;
import ch.milosz.reactnative.audio.MeetingAudioHelper;
import ch.milosz.reactnative.event.MeetingStateEvent;
import ch.milosz.reactnative.event.MeetingUserEvent;
import ch.milosz.reactnative.initsdk.AuthParams;
import ch.milosz.reactnative.initsdk.InitAuthSDKCallback;
import ch.milosz.reactnative.initsdk.InitAuthSDKHelper;
import ch.milosz.reactnative.user.MeetingUserCallback;
import ch.milosz.reactnative.video.MeetingVideoCallback;
import ch.milosz.reactnative.video.MeetingVideoHelper;
import us.zoom.sdk.InMeetingNotificationHandle;
import us.zoom.sdk.InMeetingUserInfo;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingError;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingServiceListener;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;

import static ch.milosz.reactnative.event.EventConstants.MEETING_USER_JOIN;
import static ch.milosz.reactnative.event.EventConstants.MEETING_USER_LEFT;

public class ZoomModule extends ReactContextBaseJavaModule implements
        MeetingServiceListener,
        InitAuthSDKCallback,
        LifecycleEventListener,
        PermissionListener,
        MeetingAudioCallback.AudioEvent,
        MeetingVideoCallback.VideoEvent,
        MeetingUserCallback.UserEvent {

  private static final String TAG = "ZoomModule";

  public final static int REQUEST_CAMERA_CODE = 1010;

  public final static int REQUEST_AUDIO_CODE = 1011;

  public static final String MEETING_EVENT = "onMeetingEvent";

  private final ReactContext mContext;
  private final AtomicBoolean mIsObserverRegistered = new AtomicBoolean(false);
  private ZoomSDK mZoomSDK;
  private MeetingAudioHelper meetingAudioHelper;
  private MeetingVideoHelper meetingVideoHelper;

  public ZoomModule(ReactApplicationContext context) {
    super(context);
    this.mContext = context;
    this.mContext.addLifecycleEventListener(this);
  }

  @NonNull
  @Override
  public String getName() {
    return "ZoomModule";
  }

  @ReactMethod
  public void toast(String text) {
    Toast.makeText(mContext, text, Toast.LENGTH_SHORT).show();
  }

  @ReactMethod
  public void initZoomSDK(ReadableMap data) {
    String domain = data.getString("domain");
    String clientKey = data.getString("clientKey");
    String clientSecret = data.getString("clientSecret");
    AuthParams.init(domain, clientKey, clientSecret);

    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      mZoomSDK = ZoomSDK.getInstance();
      InitAuthSDKHelper.getInstance().initSDK(mContext, ZoomModule.this);
      //if (mZoomSDK.isInitialized()) {
      // ZoomSDK.getInstance().getMeetingSettingsHelper().enable720p(true);
      //}
    });
  }

  @Override
  public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
    Log.i(TAG, "onZoomSDKInitializeResult, errorCode=" + errorCode + ", internalErrorCode=" + internalErrorCode);
    if (errorCode != ZoomError.ZOOM_ERROR_SUCCESS) {
      Log.e(TAG, "Failed to initialize Zoom SDK. Error: " + errorCode + ", internalErrorCode=" + internalErrorCode);
    } else {
      Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
        ZoomSDK.getInstance().getMeetingSettingsHelper().enable720p(false);
        ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedMeetingUIEnabled(true);
        ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedNotificationData(null, handle);
        ZoomSDK.getInstance().getMeetingService().addListener(ZoomModule.this);

        meetingAudioHelper = new MeetingAudioHelper(audioCallBack);
        meetingVideoHelper = new MeetingVideoHelper(mContext.getCurrentActivity(), videoCallBack);

        MeetingAudioCallback.getInstance().addListener(this);
        MeetingVideoCallback.getInstance().addListener(this);
        MeetingUserCallback.getInstance().addListener(this);
      });
      Log.d(TAG, "Initialize Zoom SDK successfully.");
    }
  }

  MeetingAudioHelper.AudioCallBack audioCallBack = new MeetingAudioHelper.AudioCallBack() {
    @Override
    public boolean requestAudioPermission() {
      if (Build.VERSION.SDK_INT >= 23 && checkSelfPermission(android.Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(Objects.requireNonNull(mContext.getCurrentActivity()), new String[]{android.Manifest.permission.RECORD_AUDIO}, REQUEST_AUDIO_CODE);
        return false;
      }
      return true;
    }

    @Override
    public void updateAudioButton() {
    }
  };

  MeetingVideoHelper.VideoCallBack videoCallBack = new MeetingVideoHelper.VideoCallBack() {
    @Override
    public boolean requestVideoPermission() {

      if (Build.VERSION.SDK_INT >= 23 && checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(Objects.requireNonNull(mContext.getCurrentActivity()), new String[]{android.Manifest.permission.CAMERA}, REQUEST_CAMERA_CODE);
        return false;
      }
      return true;
    }

    @Override
    public void showCameraList(PopupWindow popupWindow) {
    }
  };

  public int checkSelfPermission(String permission) {
    if (permission == null || permission.length() == 0) {
      return PackageManager.PERMISSION_DENIED;
    }
    try {
      return Objects.requireNonNull(mContext.getCurrentActivity()).checkPermission(permission, android.os.Process.myPid(), android.os.Process.myUid());
    } catch (Throwable e) {
      return PackageManager.PERMISSION_DENIED;
    }
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    if (permissions == null || grantResults == null) {
      return false;
    }

    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      for (int i = 0; i < permissions.length; i++) {
        if (Manifest.permission.RECORD_AUDIO.equals(permissions[i])) {
          if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
            meetingAudioHelper.switchAudio();
          }
        } else if (Manifest.permission.CAMERA.equals(permissions[i])) {
          if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
            meetingVideoHelper.switchVideo();
          }
        }
      }
    });

    return true;
  }

  InMeetingNotificationHandle handle = (context, intent) -> true;

  @Override
  public void onZoomAuthIdentityExpired() {
    Log.d(TAG, "onZoomAuthIdentityExpired");
  }

  @Override
  public void onMeetingStatusChanged(MeetingStatus meetingStatus, int errorCode, int internalErrorCode) {
    Log.d(TAG, "onMeetingStatusChanged " + meetingStatus + ":" + errorCode + ":" + internalErrorCode);
    if (!mZoomSDK.isInitialized()) {
      return;
    }
    if (meetingStatus == MeetingStatus.MEETING_STATUS_INMEETING) {
      Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
        if (meetingVideoHelper != null) {
          meetingVideoHelper.checkVideoRotation(mContext);
        }
      });
    }
    if (mIsObserverRegistered.get()) {
      MeetingStateEvent event = new MeetingStateEvent(meetingStatus);
      sendEvent(event.toParams());
    }
  }

  @ReactMethod
  public void joinMeeting(ReadableMap data) {
    final String roomNumber = data.getString(ZoomConstants.ARG_ROOM_NUMBER);
    final String roomPassword = data.getString(ZoomConstants.ARG_ROOM_PASSWORD);
    final String userDisplayName = data.getString(ZoomConstants.ARG_USER_DISPLAY_NAME);
    final String userName = data.getString(ZoomConstants.ARG_USER_NAME);
    final String email = data.getString(ZoomConstants.ARG_EMAIL);
    final String userPassword = data.getString(ZoomConstants.ARG_USER_PASSWORD);

    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      if (!mZoomSDK.isInitialized()) {
        // ZoomModule.this.toast("Init SDK First");
        InitAuthSDKHelper.getInstance().initSDK(mContext, ZoomModule.this);
        return;
      }

      final MeetingService meetingService = mZoomSDK.getMeetingService();
      if (meetingService.getMeetingStatus() != MeetingStatus.MEETING_STATUS_IDLE) {
        long lMeetingNo = 0;
        try {
          lMeetingNo = Long.parseLong(roomNumber);
        } catch (NumberFormatException e) {
          // TODO send invalid room number event
          return;
        }

        if (meetingService.getCurrentRtcMeetingNumber() == lMeetingNo) {
          meetingService.returnToMeeting(mContext.getCurrentActivity());
          Log.w(TAG, "Already joined zoom meeting");
          return;
        }
      }

      ZoomSDK.getInstance().getSmsService().enableZoomAuthRealNameMeetingUIShown(false);

      JoinMeetingParams params = new JoinMeetingParams();
      params.meetingNo = roomNumber;
      params.password = roomPassword;
      params.displayName = userName;
      JoinMeetingOptions options = new JoinMeetingOptions();

      int startMeetingResult = meetingService.joinMeetingWithParams(mContext.getCurrentActivity(), params, options);
      Log.i(TAG, "joinMeeting, result=" + startMeetingResult);

      if (startMeetingResult != MeetingError.MEETING_ERROR_SUCCESS) {
        // TODO send event failed join meeting
      }
    });
  }

  @ReactMethod
  public void leaveCurrentMeeting() {
    if (mZoomSDK.getInMeetingService() == null) {
      return;
    }
    mZoomSDK.getInMeetingService().leaveCurrentMeeting(false);
  }

  @ReactMethod
  public void getParticipants(final Callback callback) {
    if (mZoomSDK.getInMeetingService() == null) {
      return;
    }
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      List<Long> userIds = mZoomSDK.getInMeetingService().getInMeetingUserList();
      if (userIds == null) {
        return;
      }
      WritableArray array = new WritableNativeArray();
      for (Long userId : userIds) {
        array.pushString(userId.toString());
      }
      callback.invoke(null, array);
    });
  }

  @ReactMethod
  public void getUserInfo(final String userId, final Callback callback) {
    if (mZoomSDK.getInMeetingService() == null) {
      return;
    }
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      InMeetingUserInfo info = mZoomSDK.getInMeetingService().getUserInfoById(Long.parseLong(userId));
      WritableMap map = new WritableNativeMap();
      map.putInt(ZoomConstants.ARG_USER_ID, (int) info.getUserId());
      //      map.putString(RNZoomConstants.ARG_PARTICIPANT_ID, info.getParticipantID());
      map.putString(ZoomConstants.ARG_USER_NAME, info.getUserName());
      map.putString(ZoomConstants.ARG_AVATAR_PATH, info.getAvatarPath());
      callback.invoke(null, map);
    });
  }

  @ReactMethod
  public void onMyAudio() {
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      meetingAudioHelper.switchAudio();
    });
  }

  @ReactMethod
  public void offMyAudio() {
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      meetingAudioHelper.switchAudio();
    });
  }

  @ReactMethod
  public void onOffMyVideo() {
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      meetingVideoHelper.switchVideo();
    });
  }

  @ReactMethod
  public void switchMyCamera() {
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      meetingVideoHelper.switchCamera();
    });
  }

  @ReactMethod
  public void startObserverEvent() {
    Log.i(TAG, "registerListener");
    mIsObserverRegistered.set(true);
  }

  @ReactMethod
  public void stopObserverEvent() {
    Log.i(TAG, "unregisterListener");
    mIsObserverRegistered.set(false);
  }

  private void sendEvent(@Nullable WritableMap params) {
    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit(MEETING_EVENT, params);
  }

  // React LifeCycle
  @Override
  public void onHostDestroy() {
    Log.d(TAG, "onHostDestroy: ");
    //    mContext.getCurrentActivity().runOnUiThread(new Runnable() {
    //      @Override
    //      public void run() {
    //        if (mZoomSDK.isInitialized()) {
    //          MeetingService meetingService = mZoomSDK.getMeetingService();
    //          meetingService.removeListener(ZoomModule.this);
    //          InMeetingService inMeetingService = mZoomSDK.getInMeetingService();
    //          inMeetingService.removeListener(ZoomModule.this);
    //        }
    //      }
    //    });
  }

  @Override
  public void onHostPause() {
    Log.d(TAG, "onHostPause: ");
  }

  @Override
  public void onHostResume() {
    Log.d(TAG, "onHostResume: ");
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      if (meetingVideoHelper != null) {
        meetingVideoHelper.checkVideoRotation(mContext);
      }
    });
  }

  @Override
  public void onMeetingUserJoin(List<Long> list) {
    if (!mIsObserverRegistered.get() || list == null || list.isEmpty()) {
      return;
    }
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      for (Long userId : list) {
        MeetingUserEvent event = new MeetingUserEvent(MEETING_USER_JOIN, String.valueOf(userId));
        InMeetingUserInfo info = mZoomSDK.getInMeetingService().getUserInfoById(userId);
        if (info != null) {
          event.setUserName(info.getUserName());
          event.setVideoStatus(info.getVideoStatus() != null && info.getVideoStatus().isSending());
          event.setAudioStatus(info.getAudioStatus() != null && info.getAudioStatus().isTalking());
          event.setVideoRatio("1.0");
          event.setHost(info.getInMeetingUserRole() == InMeetingUserInfo.InMeetingUserRole.USERROLE_HOST);
        }
        sendEvent(event.toParams());
      }
    });
  }

  @Override
  public void onMeetingUserLeave(List<Long> list) {
    if (!mIsObserverRegistered.get() || list == null || list.isEmpty()) {
      return;
    }
    Objects.requireNonNull(mContext.getCurrentActivity()).runOnUiThread(() -> {
      for (Long userId : list) {
        MeetingUserEvent event = new MeetingUserEvent(MEETING_USER_LEFT, String.valueOf(userId));
        InMeetingUserInfo info = mZoomSDK.getInMeetingService().getUserInfoById(userId);
        if (info != null) {
          event.setUserName(info.getUserName());
        }
        sendEvent(event.toParams());
      }
    });
  }

  @Override
  public void onSilentModeChanged(boolean inSilentMode) {
    Log.d(TAG, "onSilentModeChanged: " + inSilentMode);
  }

  @Override
  public void onUserAudioStatusChanged(long userId) {
    Log.d(TAG, "onUserAudioStatusChanged: " + userId);
  }

  @Override
  public void onUserAudioTypeChanged(long userId) {
    Log.d(TAG, "onUserAudioTypeChanged: " + userId);
  }

  @Override
  public void onMyAudioSourceTypeChanged(int type) {
    Log.d(TAG, "onMyAudioSourceTypeChanged: " + type);
  }

  @Override
  public void onUserVideoStatusChanged(long userId) {
    Log.d(TAG, "onUserVideoStatusChanged: " + userId);
  }
}
