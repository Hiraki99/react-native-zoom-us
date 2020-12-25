/**
 * Created by juanjimenez on 07/12/2016.
 * Otomogroove ltd 2017
 */

"use strict";
import React, { PureComponent } from "react";
import {requireNativeComponent} from "react-native";
const NativeZoomView = requireNativeComponent("RNZoomView", RNZoomView);

export default class RNZoomView extends PureComponent {
  constructor(props) {
    super(props);
  }

  render() {
    return (
        <NativeZoomView style={this.props.style} />
    );
  }
}

