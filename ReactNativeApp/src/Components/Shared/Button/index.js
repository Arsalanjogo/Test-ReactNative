import React from 'react';
import {Text, ActivityIndicator, View} from 'react-native';

//Components
import {RippleEffect} from '../../index';

//Styling
import styles from './styles';

//Themes
import {Colors, Metrics} from '../../../Theme';
import {BarIndicator, MaterialIndicator} from 'react-native-indicators';
import CustomIcon from '../CustomIcon';

export default function Button(props) {
  const {
    title = 'Button Title',
    onPress = () => {},
    style,
    textStyle,
    children,
    disabled = false,
    loading = false,
    secondary = false,
    round = true,
    background = false,
    backgroundStyle,
    borderRadius = round ? Metrics.height * 0.03 : 0,
    withIcon = false,
    IconName,
    iconStyle
  } = props;

  return (
    <View style={[background && styles.background, backgroundStyle]}>
      <RippleEffect
        rippleContainerBorderRadius={borderRadius}
        rippleOpacity={0.8}
        rippleDuration={500}
        onPress={onPress}
        disabled={disabled || loading}
        style={[
          styles.container,
          {
            backgroundColor: secondary ? Colors.textDark : Colors.primary,
          },
          style,
        ]}>
        {children ? (
          children
        ) : (
          <View style={styles.button}>
            {withIcon && <CustomIcon name={IconName} style={iconStyle}/>}
            <Text
              style={[
                styles.buttonText,
                {
                  color: secondary ? Colors.textLight : Colors.textDark,
                  marginRight: loading ? Metrics.height * 0.03 + 10 : 0,
                },
                textStyle,
              ]}>
              {title}
            </Text>
            {loading && (
              <MaterialIndicator
                style={styles.loader}
                color={secondary ? Colors.textLight : Colors.textDark}
                size={Metrics.height * 0.03}
              />
            )}
          </View>
        )}
      </RippleEffect>
    </View>
  );
}
