/**
 * Created by juanjimenez on 07/12/2016.
 * Otomogroove ltd 2017
 */

'use strict';
import React, {forwardRef, PureComponent, useImperativeHandle} from 'react';
import {requireNativeComponent, UIManager, findNodeHandle} from 'react-native';
const NativeZoomView = requireNativeComponent('RNZoomUs', RNZoomView);

const config = {
  zoom: {
    appKey: 'fWBEHJbyD7SHbkTcX4LnfMVMkMV6biVtWDor', // TODO: appKey
    appSecret: 'TfuTLZCeeFhbwSuuq95gIQvVkxWyxyDJbhgX', // TODO appSecret
    domain: 'zoom.us',
  },
};

const RNZoomViewRef = (props, ref) => {
  const nativeZoomViewRef = React.useRef();

  const joinMeetingWithPassword = React.useCallback((data) => {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(nativeZoomViewRef),
      UIManager.RNZoomUs.Commands.initZoomSDK,
      [data],
    );
  }, []);

  React.useEffect(() => {
    UIManager.dispatchViewManagerCommand(
      nativeZoomViewRef,
      UIManager.RNZoomUs.Commands.initZoomSDK,
      [
        {
          domain: 'zoom.us',
          clientKey: 'yaEkS5rguwHNuFvqOsDh8VMvZOkRSNEMJpjn',
          clientSecret: 'ngtmOzHAu0FwI55Faoe0AD3tVm86D3XfkzTj',
        },
      ],
    );
  }, []);

  useImperativeHandle(ref, () => ({
    joinMeetingWithPassword: (data) => {
      joinMeetingWithPassword(data);
    },
  }));

  return <NativeZoomView ref={nativeZoomViewRef} style={props.style} userID={props.userID || 'local_user'} />;
};

const RNZoomView = React.forwardRef(RNZoomViewRef);

export default RNZoomView;
