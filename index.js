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

export const initZoomSdk = (domain, clientKey, clientSecret) => {
  ZoomModule.initZoomSDK({
    domain,
    clientKey,
    clientSecret,
  });
};

const RNZoomViewRef = (props, ref) => {
  const {onEvent} = props;
  const nativeZoomViewRef = React.useRef();

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
      return new Promise((res) => {
        ZoomModule.getParticipants((err, members) => {
          if (err) {
            return res({error: true, members: []});
          }
          return res({error: false, members});
        });
      });
    },
    getUserInfo: (userId) => {
      return new Promise((res) => {
        ZoomModule.getUserInfo(userId, (error, info) => {
          if (error) {
            return res({error: true, info: null});
          }
          return res({error: false, info});
        });
      });
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
