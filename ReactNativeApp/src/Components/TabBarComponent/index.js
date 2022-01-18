import React, {Component} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
} from 'react-native';
import {SafeAreaInsetsContext} from 'react-native-safe-area-context';
import {CustomText} from '..';
import {Metrics, Colors} from '../../Theme';
import CustomIcon from '../Shared/CustomIcon';

class TabBarComponent extends Component {
  render() {
    const {state, descriptors, navigation,icons} = this.props;
    return (
      <View style={{backgroundColor:Colors.backgroundDark}}>
        <SafeAreaInsetsContext.Consumer>
        {insets => (
          <View
            style={[
              styles.tabBar,
              {
                marginBottom: insets.bottom,
              },
            ]}>
            {state.routes.map((route, index) => {
              const {options} = descriptors[route.key];
              const isFocused = state.index === index;
              const onPress = () => {
                const event = navigation.emit({
                  type: 'tabPress',
                  target: route.key,
                });
                if (!isFocused && !event.defaultPrevented) {
                  navigation.navigate(route.name);
                }
              };
              return (
                <TouchableOpacity
                  activeOpacity={0.8}
                  accessibilityRole="button"
                  accessibilityStates={isFocused ? ['selected'] : []}
                  accessibilityLabel={options.tabBarAccessibilityLabel}
                  testID={options.tabBarTestID}
                  onPress={onPress}
                  style={styles.tab}>
                  <View>
                    <CustomIcon name={icons[route.name]} color={isFocused ? Colors.primary : Colors.textLight} size={Metrics.largeFont} style={styles.icon}/>
                    <CustomText
                      style={{
                        color: isFocused ? Colors.primary : Colors.textDark,
                        textAlign: 'center',
                        fontSize:Metrics.xsmallFont
                      }}>
                      {route.name}
                    </CustomText>
                  </View>
                </TouchableOpacity>
              );
            })}
          </View>
        )}
      </SafeAreaInsetsContext.Consumer>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  tabBar: {
    width: '100%',
    flexDirection: 'row',
    height: 60,
    borderColor: Colors.backgroundLight,
    borderTopWidth: 0.5,
    backgroundColor:Colors.backgroundDark
  },
  tab:{
    width: '20%',
    justifyContent: 'center',
    paddingVertical:20
  },
  icon: {
    fontSize:30,
    alignSelf:'center'
  },
});

export default TabBarComponent;
