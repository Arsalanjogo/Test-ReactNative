// @flow
import React from 'react';

import {ActivityIndicator, View} from 'react-native';
import {Colors} from '../../Theme';

export default class LoaderViewApi extends React.PureComponent {
  static defaultProps = {};

  render() {
    const {style} = this.props;

    return (
      <View
        style={[
          {
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            backgroundColor: 'black',
          },
          style,
        ]}>
        <ActivityIndicator animating size="large" color={Colors.primary} />
      </View>
    );
  }
}
