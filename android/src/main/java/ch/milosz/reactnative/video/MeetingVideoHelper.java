package ch.milosz.reactnative.video;

import android.app.Service;
import android.content.Context;
import android.view.Display;
import android.view.WindowManager;
import android.widget.PopupWindow;

import java.util.List;

import us.zoom.sdk.CameraDevice;
import us.zoom.sdk.InMeetingVideoController;
import us.zoom.sdk.ZoomSDK;

public class MeetingVideoHelper {


  private InMeetingVideoController mInMeetingVideoController;

  private Context activity;

  private VideoCallBack callBack;

  public interface VideoCallBack {

    boolean requestVideoPermission();

    void showCameraList(PopupWindow popupWindow);

  }

  public MeetingVideoHelper(Context activity, VideoCallBack callBack) {
    this.activity = activity;
    this.callBack = callBack;
    mInMeetingVideoController = ZoomSDK.getInstance().getInMeetingService().getInMeetingVideoController();

  }

  public void checkVideoRotation(Context context) {
    Display display = ((WindowManager) context.getSystemService(Service.WINDOW_SERVICE)).getDefaultDisplay();
    int displayRotation = display.getRotation();
    mInMeetingVideoController.rotateMyVideo(displayRotation);
  }

  public void switchVideo() {
    if (null == callBack || !callBack.requestVideoPermission()) {
      return;
    }
    if (mInMeetingVideoController.isMyVideoMuted()) {
      if (mInMeetingVideoController.canUnmuteMyVideo()) {
        mInMeetingVideoController.muteMyVideo(false);
      }
    } else {
      mInMeetingVideoController.muteMyVideo(true);
    }
  }

  public void switchCamera() {
    if (mInMeetingVideoController.canSwitchCamera()) {
      mInMeetingVideoController.switchToNextCamera();
//      List<CameraDevice> devices = mInMeetingVideoController.getCameraDeviceList();
//      if (devices != null && devices.size() > 1) {
//        if (null != callBack) {
//          callBack.showCameraList(null);
//        }
//      } else {
//        mInMeetingVideoController.switchToNextCamera();
//      }
    }
  }
}
