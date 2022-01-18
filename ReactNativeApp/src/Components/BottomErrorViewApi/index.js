// @flow
import React from 'react';
import PropTypes from 'prop-types';
import {View, Text} from 'react-native';

import {Button} from '..';
import {BUTTON_TYPE} from '../../Config/Constants';

export default class BottomErrorViewApi extends React.PureComponent {
  static defaultProps = {
    errorMessage: PropTypes.string.isRequired,
    onPressRetry: PropTypes.func.isRequired,
  };

  render() {
    const {errorMessage, onPressRetry} = this.props;
    return (
      <View
        style={{
          flexDirection: 'row',
          margin: 16,
          justifyContent: 'center',
          alignItems: 'center',
        }}>
        {/* <Image source={Images.error} /> */}
        <Text
          style={{
            //   flex: 1,
            // marginHorizontal: 12,
            textAlign: 'center',
          }}>
          {errorMessage}
        </Text>
        {/* <ButtonView
          onPress={onPressRetry}
          style={{padding: 8, backgroundColor: 'red'}}>
          <Text>Retry</Text>
        </ButtonView> */}
        <Button
          title="Retry"
          onPress={onPressRetry}
          type={BUTTON_TYPE.GREY_BORDER}
          container={{
            height: undefined,
            marginLeft: 6,
            padding: 6,
            marginTop: 0,
          }}
          titleTextStyle={{fontSize: 13}}
        />
      </View>
    );
  }
}
