package ch.milosz.reactnative.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Handler;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.PixelCopy;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.glidebitmappool.GlideBitmapPool;
import com.zipow.videobox.sdk.SDKVideoView;

import ch.milosz.reactnative.R;
import us.zoom.sdk.InMeetingUserInfo;
import us.zoom.sdk.MobileRTCVideoUnitAspectMode;
import us.zoom.sdk.MobileRTCVideoUnitRenderInfo;
import us.zoom.sdk.MobileRTCVideoView;
import us.zoom.sdk.MobileRTCVideoViewManager;
import us.zoom.sdk.ZoomSDK;

public class ZoomView extends FrameLayout implements SDKVideoView.c {

  private static final String TAG = "ZoomView";

  private MobileRTCVideoView mDefaultVideoView;
  private SDKVideoView surfaceView;

  private ImageView mThumbnail;
  private String mUserId;
  private Bitmap mThumbnailBitmap;

  public ZoomView(@NonNull Context context) {
    this(context, null);
  }

  public ZoomView(@NonNull Context context, @Nullable AttributeSet attrs) {
    this(context, attrs, 0);
  }

  public ZoomView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
  }

  @Override
  protected void onFinishInflate() {
    super.onFinishInflate();
    mDefaultVideoView = findViewById(R.id.videoView);
    MobileRTCVideoView root = mDefaultVideoView.findViewById(R.id.videoView);
    try {
      surfaceView = (SDKVideoView) ((RelativeLayout) root.getChildAt(0)).getChildAt(0);
      View shareView = ((RelativeLayout) root.getChildAt(0)).getChildAt(1);
      shareView.setVisibility(GONE);
      surfaceView.setListener(this);
    } catch (Exception e) {
      Log.e(TAG, "Failed to get surface video view", e);
    }
    mThumbnail = findViewById(R.id.thumbnail);
  }

  public void setAttendeeVideoUnit(String userId) {
    MobileRTCVideoViewManager mDefaultVideoViewMgr = mDefaultVideoView.getVideoViewManager();
    if (mDefaultVideoViewMgr == null) {
      return;
    }
    if (!TextUtils.isEmpty(mUserId)) {
      mDefaultVideoViewMgr.removeAttendeeVideoUnit(Long.parseLong(mUserId));
    }
    if (!TextUtils.isEmpty(userId)) {
      mUserId = userId;
      MobileRTCVideoUnitRenderInfo renderInfo = new MobileRTCVideoUnitRenderInfo(0, 0, 100, 100);
      renderInfo.aspect_mode = MobileRTCVideoUnitAspectMode.VIDEO_ASPECT_PAN_AND_SCAN;
      mDefaultVideoViewMgr.addAttendeeVideoUnit(Long.parseLong(userId), renderInfo);
    }
  }

  @Override
  public void surfaceCreated() {
    // Distract view to wait for video view fully rendered
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      // Show thumbnail is last screenshot video view
      mThumbnail.setVisibility(VISIBLE);
    } else {
      // For Android below 26, screenshot thumbnail don't work well, hide zoom view to show system user avatar
      setVisibility(GONE);
    }
    // Set delay time for video view show to user
    new Handler().postDelayed(() -> {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        // Hide last screenshot thumbnail
        mThumbnail.setVisibility(GONE);
      } else {
        // Show zoom view
        setVisibility(VISIBLE);
      }
    }, 1000);
  }

  @Override
  public void surfaceDestroyed() {
    if (!TextUtils.isEmpty(mUserId)) {
      InMeetingUserInfo info = ZoomSDK.getInstance().getInMeetingService().getUserInfoById(Long.parseLong(mUserId));
      if (info != null && info.getVideoStatus() != null && info.getVideoStatus().isSending()) {
        screenshotThumbnail();
      }
    }
  }

  public void screenshotThumbnail() {
    if (surfaceView == null) {
      Log.e(TAG, "screenshotThumbnail: failed to get surface view");
      return;
    }
    int videoWidth = surfaceView.getWidth();
    int videoHeight = surfaceView.getHeight();
    if (mThumbnailBitmap != null) {
      GlideBitmapPool.putBitmap(mThumbnailBitmap);
    }
    mThumbnailBitmap = GlideBitmapPool.getBitmap(videoWidth, videoHeight, Bitmap.Config.ARGB_8888);
    int[] locationOfViewInWindow = new int[2];
    surfaceView.getLocationInWindow(locationOfViewInWindow);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      PixelCopy.request(
              surfaceView,
              mThumbnailBitmap,
              copyResult -> {
                if (copyResult == PixelCopy.SUCCESS) {
                  mThumbnail.setImageBitmap(mThumbnailBitmap);
                } else {
                  Log.e(TAG, "screenshotThumbnail: failed to screenshot video view" + copyResult);
                }
              },
              new Handler());
    } else {
      // For Android below 26
      // Zoom view will be hidden to show system user avatar
    }
  }


  @Override
  public void beforeGLContextDestroyed() {
  }
}
