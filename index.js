'use strict';
import React, {useImperativeHandle} from 'react';
import PropTypes from 'prop-types';
import {
  requireNativeComponent,
  NativeModules,
  NativeEventEmitter,
} from 'react-native';
const NativeZoomView = requireNativeComponent('RNZoomView', RNZoomViewRef);
const {ZoomModule} = NativeModules;
const eventEmitter = new NativeEventEmitter(ZoomModule);
let subscriptionEvent;

export const initZoomSdk = (domain, clientKey, clientSecret) => {
  ZoomModule.initZoomSDK({
    domain,
    clientKey,
    clientSecret,
  });
};

export const ZoomJoinMeetingWithPassword = (data) => {
  ZoomModule.joinMeeting(data);
};
export const ZoomLeaveCurrentMeeting = () => {
  ZoomModule.leaveCurrentMeeting();
};

export const onOffAudioZoom = () => {
  ZoomModule.onOffMyAudio();
};
export const switchCameraZoom = () => {
  ZoomModule.switchMyCamera();
};

export const getParticipantsZoom = () => {
  return new Promise((res) => {
    ZoomModule.getParticipants((err, members) => {
      if (err) {
        return res({error: true, members: []});
      }
      return res({error: false, members});
    });
  });
}
export const getUserInfoZoom = (userId) => {
  return new Promise((res) => {
    ZoomModule.getUserInfo(userId, (error, info) => {
      if (error) {
        return res({error: true, info: null});
      }
      return res({error: false, info});
    });
  });
}

export const onEventListenerZoom = (onEvent = () => {}) =>{
  subscriptionEvent = eventEmitter.addListener(
    'onMeetingEvent',
    onEvent,
  );
  ZoomModule.startObserverEvent();
}

export const removeListenerZoom = () => {
  subscriptionEvent.remove();
  ZoomModule.stopObserverEvent();
  
}

const RNZoomView = (props) => {
  const {onEvent} = props;
  const nativeZoomViewRef = React.useRef();
  return (
    <NativeZoomView
      ref={nativeZoomViewRef}
      style={props.style}
      userID={props.userID || 'local_user'}
    />
  );
};

export default RNZoomView;
