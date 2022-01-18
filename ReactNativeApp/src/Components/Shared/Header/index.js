import React from 'react';
import { View, Text, TextInput, Image } from 'react-native';
import { CustomIcon, CustomText, RippleEffect } from '../../index';
import styles from './styles';
import { SafeAreaInsetsContext } from 'react-native-safe-area-context';
import { Colors } from '../../../Theme';
import { Icons, Navigator } from '../../../Utils';
import { TouchableOpacity } from 'react-native-gesture-handler';

export default function Header({
  ShareWithFriends = false,
  absolute = false, //For a header that is shown on front of some view
  search = false, //For header with search input instead of text
  title = 'Home',
  onPressLeft = () => Navigator.goBack(),
  onPressRight = () => { },
  leftIcon = search ? Icons.Profile : Icons.Left,
  rightIcon = Icons.Share,
  showRightIcon = true,
  showLeftIcon = true,
  showTitle = absolute ? false : true,
  onSearch = () => { },
  placeholder = 'Search',
  style = {},
  iconView = {},
}) {
  return (
    <SafeAreaInsetsContext.Consumer>
      {insets => (
        <View
          style={
            absolute
              ? [styles.absoluteContainer, { marginTop: insets.top }]
              : [styles.container, style]
          }>
          <View style={[styles.sideContainer, { alignItems: 'flex-end' }]}>
            {showLeftIcon ? (
              ShareWithFriends ? null : (
                <RippleEffect
                  style={[
                    [styles.iconView, iconView],
                    absolute && { backgroundColor: Colors.darkGray },
                  ]}
                  onPress={onPressLeft}>
                  <CustomIcon
                    name={leftIcon}
                    color="white"
                    style={styles.icon}
                  />
                </RippleEffect>
              )
            ) : null}
          </View>
          {search ? (
            <TextInput
              style={styles.textInput}
              placeholder={placeholder}
              placeholderTextColor={Colors.placeholder}
              onChangeText={onSearch}
            />
          ) : (
            <View style={styles.textView}>
              {showTitle ? (
                <CustomText style={styles.title} numberOfLines={2}>
                  {title}
                </CustomText>
              ) : null}
            </View>
          )}
          <View style={[styles.sideContainer, { alignItems: 'flex-start' }]}>
            {showRightIcon ? (
              <RippleEffect
                style={[
                  styles.iconView,
                  absolute && { backgroundColor: Colors.darkGray },
                ]}
                onPress={onPressRight}>
                {ShareWithFriends ? (
                  <TouchableOpacity
                    activeOpacity={0.8}
                    onPress={() => console.log('Back')}>
                    <Image source={rightIcon} style={styles.icon} />
                  </TouchableOpacity>
                ) : (
                  <CustomIcon
                    name={rightIcon}
                    color="white"
                    style={styles.icon}
                  />
                )}
              </RippleEffect>
            ) : null}
          </View>
        </View>
      )}
    </SafeAreaInsetsContext.Consumer>
  );
}
