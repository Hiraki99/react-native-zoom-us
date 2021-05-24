'use strict';
import React, {useImperativeHandle} from 'react';
import PropTypes from 'prop-types';
import {
  requireNativeComponent,
  NativeModules,
  NativeEventEmitter,
} from 'react-native';
const NativeZoomView = requireNativeComponent('RNZoomView', RNZoomView);
const {ZoomModule} = NativeModules;
const eventEmitter = new NativeEventEmitter(ZoomModule);
let subscriptionEvent;

export const initZoomSdk = (domain, clientKey, clientSecret) => {
  return new Promise((res) => {
    ZoomModule.initZoomSDK({
      domain,
      clientKey,
      clientSecret,
    }, (rs) => {
      return res(rs)
    });
  });
};

export const ZoomJoinMeetingWithPassword = (data) => {
  ZoomModule.joinMeeting(data);
};
export const ZoomLeaveCurrentMeeting = () => {
  ZoomModule.leaveCurrentMeeting();
};

export const onMyAudio = () => {
  ZoomModule.onMyAudio();
};

export const offMyAudio = () => {
  ZoomModule.offMyAudio();
};

export const onAudioZoom = () => {
  ZoomModule.onMyAudio();
};

export const offAudioZoom = () => {
  ZoomModule.offMyAudio();
};

export const onOffMyVideoZoom = () => {
  ZoomModule.onOffMyVideo();
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
  ZoomModule.stopObserverEvent();
  eventEmitter.removeAllListeners("onMeetingEvent");
}

export const toast = (text) => {
  ZoomModule.toast(text);
}

const RNZoomView = (props) => {
  const {onEvent} = props;
  const nativeZoomViewRef = React.useRef();
  return (
    <NativeZoomView
      ref={nativeZoomViewRef}
      style={props.style}
      userID={props.userID || ''}
    />
  );
};

export default RNZoomView;
