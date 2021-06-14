package ch.milosz.reactnative;

import android.annotation.SuppressLint;
import android.view.View;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

@SuppressLint("InflateParams")
public class ZoomViewManager extends SimpleViewManager<View> {

  @NonNull
  @Override
  public String getName() {
    return "RNZoomView";
  }

  @NonNull
  @Override
  protected View createViewInstance(@NonNull ThemedReactContext reactContext) {
    return new View(reactContext);
  }

  @ReactProp(name = "userID")
  public void setAttendeeVideoUnit(View view, String userID) {
  }
}
