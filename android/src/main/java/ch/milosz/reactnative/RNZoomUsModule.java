package ch.milosz.reactnative;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

public class RNZoomUsModule extends ReactContextBaseJavaModule {

  public RNZoomUsModule(ReactApplicationContext context) {
    super(context);
  }

  @NonNull
  @Override
  public String getName() {
    return "ZoomModule";
  }

  @ReactMethod
  public void toast(String text) {
  }

  @ReactMethod
  public void initZoomSDK(ReadableMap data, Callback callback) {
  }

  @ReactMethod
  public void joinMeeting(ReadableMap data) {
  }

  @ReactMethod
  public void leaveCurrentMeeting() {
  }

  @ReactMethod
  public void getParticipants(final Callback callback) {
  }

  @ReactMethod
  public void getUserInfo(final String userId, final Callback callback) {
  }

  @ReactMethod
  public void onMyAudio() {
  }

  @ReactMethod
  public void offMyAudio() {
  }

  @ReactMethod
  public void onOffMyVideo() {
  }

  @ReactMethod
  public void switchMyCamera() {
  }

  @ReactMethod
  public void startObserverEvent() {
  }

  @ReactMethod
  public void stopObserverEvent() {
  }
}
