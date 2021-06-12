package ch.milosz.reactnative;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import ch.milosz.reactnative.view.ZoomView;

@SuppressLint("InflateParams")
public class ZoomViewManager extends SimpleViewManager<ZoomView> {

  @NonNull
  @Override
  public String getName() {
    return "RNZoomView";
  }

  @NonNull
  @Override
  protected ZoomView createViewInstance(@NonNull ThemedReactContext reactContext) {
    LayoutInflater inflater = (LayoutInflater) reactContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    return (ZoomView) inflater.inflate(R.layout.layout_meeting_content_normal, null);
  }

  @ReactProp(name = "userID")
  public void setAttendeeVideoUnit(ZoomView view, String userID) {
    view.setAttendeeVideoUnit(userID);
  }
}
