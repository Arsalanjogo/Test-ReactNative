import React from 'react';
import {View, StatusBar, Platform} from 'react-native';
import {Colors} from '../../../Theme'
import {SafeAreaInsetsContext} from 'react-native-safe-area-context';

export default function RootView(props) {
  const {
    style,
    children,
    top,
    bottom,
    statusBar = Colors.backgroundDark,
    barStyle = 'light-content',
    background = Colors.backgroundDark
  } = props;
  
  return (
    <View style={{flex: 1, backgroundColor: statusBar}}>
      <StatusBar barStyle={barStyle} backgroundColor={background} />
      <SafeAreaInsetsContext.Consumer>
        {insets => (
          <View
            style={{
              flex: 1,
              ...Platform.select({
                ios: {
                  marginTop: top == 0 ? top : insets.top,
                  paddingBottom: bottom == 0 ? bottom : insets.bottom,
                },
              }),
              backgroundColor: background,
              ...style,
            }}>
            {children}
          </View>
        )}
      </SafeAreaInsetsContext.Consumer>
    </View>
  );
}
