// @flow
import React from 'react';

import {ActivityIndicator, View} from 'react-native';
import {Colors} from '../../Theme';

export default class BottomLoaderViewApi extends React.PureComponent {
  static defaultProps = {};

  render() {
    return (
      <View
        style={{padding: 16, justifyContent: 'center', alignItems: 'center'}}>
        <ActivityIndicator animating size="large" color={Colors.primary} />
      </View>
    );
  }
}
