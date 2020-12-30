'use strict';
import React, {useImperativeHandle} from 'react';
import PropTypes from 'prop-types';
import {
  requireNativeComponent,
  NativeModules,
  NativeEventEmitter,
  // Animated,
  // PanResponder,
} from 'react-native';
const NativeZoomView = requireNativeComponent('RNZoomView', RNZoomViewRef);
const {ZoomModule} = NativeModules;
const eventEmitter = new NativeEventEmitter(ZoomModule);

const RNZoomViewRef = (props, ref) => {
  const {onEvent} = props;
  const nativeZoomViewRef = React.useRef();

  React.useEffect(() => {
    ZoomModule.initZoomSDK({
      domain: 'zoom.us',
      clientKey: 'yaEkS5rguwHNuFvqOsDh8VMvZOkRSNEMJpjn',
      clientSecret: 'ngtmOzHAu0FwI55Faoe0AD3tVm86D3XfkzTj',
    });
  }, []);

  React.useEffect(() => {
    const subscriptionEvent = eventEmitter.addListener(
      'onMeetingEvent',
      onEvent,
    );
    ZoomModule.startObserverEvent();

    return () => {
      subscriptionEvent.remove();
      ZoomModule.stopObserverEvent();
    };
  }, [onEvent]);

  const joinMeetingWithPassword = React.useCallback((data) => {
    ZoomModule.joinMeeting(data);
  }, []);

  useImperativeHandle(ref, () => ({
    joinMeetingWithPassword: (data) => {
      joinMeetingWithPassword(data);
    },
    leaveCurrentMeeting: () => {
      ZoomModule.leaveCurrentMeeting();
    },
    audio: () => {
      ZoomModule.onOffMyAudio();
    },
    video: () => {
      ZoomModule.onOffMyVideo();
    },
    switchCamera: () => {
      ZoomModule.switchMyCamera();
    },
    getParticipants: () => {
      ZoomModule.getParticipants();
    },
  }));

  return (
    <NativeZoomView
      ref={nativeZoomViewRef}
      style={props.style}
      userID={props.userID || 'local_user'}
    />
  );
};

const RNZoomView = React.forwardRef(RNZoomViewRef);

RNZoomView.propTypes = {
  onEvent: PropTypes.func,
};

RNZoomView.defaultProps = {
  onEvent: () => {},
};

export default RNZoomView;
