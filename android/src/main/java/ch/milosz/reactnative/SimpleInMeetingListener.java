package ch.milosz.reactnative;

import java.util.List;

import us.zoom.sdk.FreeMeetingNeedUpgradeType;
import us.zoom.sdk.InMeetingAudioController;
import us.zoom.sdk.InMeetingChatMessage;
import us.zoom.sdk.InMeetingEventHandler;
import us.zoom.sdk.InMeetingServiceListener;

public abstract class SimpleInMeetingListener implements InMeetingServiceListener {
  @Override
  public void onMeetingNeedPasswordOrDisplayName(boolean b, boolean b1, InMeetingEventHandler inMeetingEventHandler) {

  }

  @Override
  public void onWebinarNeedRegister() {

  }

  @Override
  public void onJoinWebinarNeedUserNameAndEmail(InMeetingEventHandler inMeetingEventHandler) {

  }

  @Override
  public void onMeetingNeedColseOtherMeeting(InMeetingEventHandler inMeetingEventHandler) {

  }

  @Override
  public void onMeetingFail(int i, int i1) {

  }

  @Override
  public void onMeetingLeaveComplete(long l) {

  }

  @Override
  public void onMeetingUserJoin(List<Long> list) {

  }

  @Override
  public void onMeetingUserLeave(List<Long> list) {

  }

  @Override
  public void onMeetingUserUpdated(long l) {

  }

  @Override
  public void onMeetingHostChanged(long l) {

  }

  @Override
  public void onMeetingCoHostChanged(long l) {

  }

  @Override
  public void onActiveVideoUserChanged(long l) {

  }

  @Override
  public void onActiveSpeakerVideoUserChanged(long l) {

  }

  @Override
  public void onSpotlightVideoChanged(boolean b) {

  }

  @Override
  public void onUserVideoStatusChanged(long l) {

  }

  @Override
  public void onUserVideoStatusChanged(long l, VideoStatus videoStatus) {

  }

  @Override
  public void onUserNetworkQualityChanged(long l) {

  }

  @Override
  public void onMicrophoneStatusError(InMeetingAudioController.MobileRTCMicrophoneError mobileRTCMicrophoneError) {

  }

  @Override
  public void onUserAudioStatusChanged(long l) {

  }

  @Override
  public void onUserAudioStatusChanged(long l, AudioStatus audioStatus) {

  }

  @Override
  public void onHostAskUnMute(long l) {

  }

  @Override
  public void onHostAskStartVideo(long l) {

  }

  @Override
  public void onUserAudioTypeChanged(long l) {

  }

  @Override
  public void onMyAudioSourceTypeChanged(int i) {

  }

  @Override
  public void onLowOrRaiseHandStatusChanged(long l, boolean b) {

  }

  @Override
  public void onMeetingSecureKeyNotification(byte[] bytes) {

  }

  @Override
  public void onChatMessageReceived(InMeetingChatMessage inMeetingChatMessage) {

  }

  @Override
  public void onSilentModeChanged(boolean b) {

  }

  @Override
  public void onFreeMeetingReminder(boolean b, boolean b1, boolean b2) {

  }

  @Override
  public void onMeetingActiveVideo(long l) {

  }

  @Override
  public void onSinkAttendeeChatPriviledgeChanged(int i) {

  }

  @Override
  public void onSinkAllowAttendeeChatNotification(int i) {

  }

  @Override
  public void onUserNameChanged(long l, String s) {

  }

  @Override
  public void onFreeMeetingNeedToUpgrade(FreeMeetingNeedUpgradeType freeMeetingNeedUpgradeType, String s) {

  }

  @Override
  public void onFreeMeetingUpgradeToGiftFreeTrialStart() {

  }

  @Override
  public void onFreeMeetingUpgradeToGiftFreeTrialStop() {

  }

  @Override
  public void onFreeMeetingUpgradeToProMeeting() {

  }
}
