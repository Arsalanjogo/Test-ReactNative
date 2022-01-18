// @flow
import React from 'react';
import PropTypes from 'prop-types';
import {View, Text} from 'react-native';

import {Button} from '../../Components';
import {Colors} from '../../Theme';

export default class ErrorViewApi extends React.PureComponent {
  static defaultProps = {
    errorMessage: PropTypes.string.isRequired,
    onPressRetry: PropTypes.func.isRequired,
  };

  render() {
    const {errorMessage, onPressRetry} = this.props;
    return (
      <View
        style={{
          flex: 1,
          alignItems: 'center',
          justifyContent: 'center',
          backgroundColor: Colors.paleGrey,
        }}>
        <Text style={{fontSize: 15}}>{errorMessage}</Text>
        <Button
          title="Retry"
          style={{height: 60, paddingHorizontal: 60}}
          onPress={onPressRetry}
        />
      </View>
    );
  }
}
