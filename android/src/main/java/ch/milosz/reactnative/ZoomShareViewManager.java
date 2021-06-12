package ch.milosz.reactnative;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import ch.milosz.reactnative.view.ZoomShareView;
import us.zoom.sdk.MobileRTCVideoUnitRenderInfo;
import us.zoom.sdk.MobileRTCVideoViewManager;
import us.zoom.sdk.ZoomSDK;

public class ZoomShareViewManager extends SimpleViewManager<ZoomShareView> {

  @NonNull
  @Override
  public String getName() {
    return "RNShareViewClientSdk";
  }

  @NonNull
  @Override
  protected ZoomShareView createViewInstance(@NonNull ThemedReactContext reactContext) {
    return new ZoomShareView(reactContext);
  }

  @ReactProp(name = "userID")
  public void setShareVideoUnit(ZoomShareView view, String userID) {
    if (!ZoomSDK.getInstance().isInitialized()) {
      return;
    }
    MobileRTCVideoViewManager defaultVideoViewMgr = view.getVideoViewManager();
    long userId = Long.parseLong(userID);
    if (userId < 0 || ZoomSDK.getInstance().getInMeetingService().isMyself(userId)) {
      defaultVideoViewMgr.removeShareVideoUnit();
      return;
    }
    MobileRTCVideoUnitRenderInfo renderInfo = new MobileRTCVideoUnitRenderInfo(0, 0, 100, 100);
    defaultVideoViewMgr.addShareVideoUnit(userId, renderInfo);
  }
}