package ch.milosz.reactnative.initsdk;

import android.content.Context;
import android.util.Log;

import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;
import us.zoom.sdk.ZoomSDKRawDataMemoryMode;

/**
 * Init and auth zoom sdk first before using SDK interfaces
 */
public class InitAuthSDKHelper implements ZoomSDKInitializeListener {

  private final static String TAG = "InitAuthSDKHelper";

  private static InitAuthSDKHelper mInitAuthSDKHelper;

  private ZoomSDK mZoomSDK;

  private InitAuthSDKCallback mInitAuthSDKCallback;

  private InitAuthSDKHelper() {
    mZoomSDK = ZoomSDK.getInstance();
  }

  public synchronized static InitAuthSDKHelper getInstance() {
    mInitAuthSDKHelper = new InitAuthSDKHelper();
    return mInitAuthSDKHelper;
  }

  /**
   * init sdk method
   */
  public void initSDK(Context context, InitAuthSDKCallback callback) {
    if (!AuthParams.isParamsFilled()) {
      throw new IllegalArgumentException("Please define auth params");
    }
    if (!mZoomSDK.isInitialized()) {
      mInitAuthSDKCallback = callback;

      ZoomSDKInitParams initParams = new ZoomSDKInitParams();
      initParams.appKey = AuthParams.APP_CLIENT_KEY;
      initParams.appSecret = AuthParams.APP_CLIENT_SECRET;
//      initParams.enableLog = true;
      initParams.enableGenerateDump = true;
//      initParams.logSize = 5;
      initParams.domain = AuthParams.WEB_DOMAIN;
      initParams.videoRawDataMemoryMode = ZoomSDKRawDataMemoryMode.ZoomSDKRawDataMemoryModeStack;
      mZoomSDK.initialize(context, this, initParams);
    }
  }

  /**
   * init sdk callback
   *
   * @param errorCode         defined in {@link us.zoom.sdk.ZoomError}
   * @param internalErrorCode Zoom internal error code
   */
  @Override
  public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
    Log.i(TAG, "onZoomSDKInitializeResult, errorCode=" + errorCode + ", internalErrorCode=" + internalErrorCode);

    if (mInitAuthSDKCallback != null) {
      mInitAuthSDKCallback.onZoomSDKInitializeResult(errorCode, internalErrorCode);
    }
  }

  @Override
  public void onZoomAuthIdentityExpired() {
    Log.e(TAG, "onZoomAuthIdentityExpired in init");
  }

  public void reset() {
    mInitAuthSDKCallback = null;
  }
}
