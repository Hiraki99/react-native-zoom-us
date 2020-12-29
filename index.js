'use strict';
import React, {useImperativeHandle} from 'react';
import PropTypes from 'prop-types';
import {
  requireNativeComponent,
  NativeModules,
  // Animated,
  // PanResponder,
} from 'react-native';
const NativeZoomView = requireNativeComponent('RNZoomView', RNZoomViewRef);

const {ZoomModule} = NativeModules;

const RNZoomViewRef = (props, ref) => {
  const nativeZoomViewRef = React.useRef();
  const joinMeetingWithPassword = React.useCallback((data) => {
    ZoomModule.joinMeeting(data);
  }, []);

  React.useEffect(() => {
    ZoomModule.initZoomSDK({
      domain: 'zoom.us',
      clientKey: 'yaEkS5rguwHNuFvqOsDh8VMvZOkRSNEMJpjn',
      clientSecret: 'ngtmOzHAu0FwI55Faoe0AD3tVm86D3XfkzTj',
    });
    return () => {
      ZoomModule.leaveCurrentMeeting();
    };
  }, []);

  useImperativeHandle(ref, () => ({
    joinMeetingWithPassword: (data) => {
      joinMeetingWithPassword(data);
    },
    leaveCurrentMeeting: () => {
      ZoomModule.leaveCurrentMeeting();
    },
  }));

  return <NativeZoomView ref={nativeZoomViewRef} style={{flex: 1}} />;
};

const RNZoomView = React.forwardRef(RNZoomViewRef);

RNZoomView.propTypes = {
  // showOption: PropTypes.bool,
  // setShowOption: PropTypes.bool,
};

RNZoomView.defaultProps = {
  // showOption: false,
  // setShowOption: () => {},
};

export default RNZoomView;
