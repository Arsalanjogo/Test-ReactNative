import {Dimensions, Platform, StatusBar} from 'react-native';
import {isIphoneX} from 'react-native-iphone-x-helper';

import {RFValue} from 'react-native-responsive-fontsize';

const width = Dimensions.get('window').width;
const height = Dimensions.get('window').height;

const STATUSBAR_HEIGHT_IOS = isIphoneX() ? 44 : 20;

export const STATUSBAR_HEIGHT =
  Platform.OS === 'ios' ? STATUSBAR_HEIGHT_IOS : StatusBar.currentHeight;

const MESSAGE_BAR_HEIGHT =
  Platform.OS === 'ios' ? (isIphoneX() ? 44 : 20) : StatusBar.currentHeight;

export const scaleFont = size => RFValue(size);

const ratio = (iosSize: number, androidSize: ?number, doScale = false) =>
  Platform.select({
    ios: doScale ? scaleVertical(iosSize) : iosSize, // iosSize,
    android: doScale
      ? scaleVertical(androidSize || iosSize)
      : androidSize || iosSize, // androidSize || iosSize,
  });

const generatedFontSize = (iosFontSize: number, androidFontSize: ?number) =>
  Platform.select({
    ios: iosFontSize,
    android: androidFontSize || iosFontSize,
  });

export default Metrics = {
  MESSAGE_BAR_HEIGHT,
  ratio,
  generatedFontSize,
  width: width,
  height: height,
  defaultMargin: width * 0.05,
  smallMargin: width * 0.03,
  xsmallMargin: width * 0.02,
  largeMargin: width * 0.08,
  xsmallFont: scaleFont(9),

  smallFont: scaleFont(11),
  defaultFont: scaleFont(13),
  mediumFont: scaleFont(15),
  largeFont: scaleFont(17),
  buttonVerticalMargin: width * 0.01,
};

// /*
//  * @flow
//  * TODO: value * ratio difference between Android and iOS is of 2 value;
//  * 16 in iOS is equals to 14 in android but this need to be verify.
//  */

// import {Dimensions, Platform, StatusBar} from 'react-native';
// import {isIphoneX} from 'react-native-iphone-x-helper';

// const {width, height} = Dimensions.get('window');

// const screenWidth = width < height ? width : height;
// const screenHeight = width < height ? height : width;

// const isKitKatAbove = Platform.OS === 'android' && Platform.Version >= 19;

// const guidelineBaseWidth = 375;
// const guidelineBaseHeight = 812;

// const scale = size => (screenWidth / guidelineBaseWidth) * +size;
// const scaleVertical = size => (screenHeight / guidelineBaseHeight) * size;

// const ratio = (iosSize: number, androidSize: ?number, doScale = false) =>
//   Platform.select({
//     ios: doScale ? scaleVertical(iosSize) : iosSize, // iosSize,
//     android: doScale
//       ? scaleVertical(androidSize || iosSize)
//       : androidSize || iosSize, // androidSize || iosSize,
//   });

// const generatedFontSize = (iosFontSize: number, androidFontSize: ?number) =>
//   Platform.select({
//     ios: iosFontSize,
//     android: androidFontSize || iosFontSize,
//   });

// const hitSlop = {top: 10, bottom: 10, left: 10, right: 10};
// /*
// const ratio = (iosSize: number, androidSize: ?number) =>
// Platform.select({
// ios: scaleVertical(iosSize),
// android: androidSize || iosSize
// });
// */

// const NAVBAR_HEIGHT = Platform.OS === 'ios' ? 44 : 56;
// const NAVBAR_HEIGHT2 = Platform.OS === 'ios' ? (isIphoneX ? 56 : 56) : 56;
// const STATUSBAR_HEIGHT_IOS = isIphoneX() ? 44 : 20;
// const STATUSBAR_HEIGHT =
//   Platform.OS === 'ios' ? STATUSBAR_HEIGHT_IOS : StatusBar.currentHeight;
// const BOTTOM_SPACE_IPHONE_X = ratio(34);
// const navBarHeight = NAVBAR_HEIGHT + STATUSBAR_HEIGHT;

// // new
// const BOTTOM_SPACING = isIphoneX() ? BOTTOM_SPACE_IPHONE_X : ratio(20);
// const SIDE_MENU_BOTTOM_SPACING =
//   Platform.OS === 'ios' ? (isIphoneX() ? 70 : 50) : 50;

// const MESSAGE_BAR_HEIGHT =
//   Platform.OS === 'ios' ? (isIphoneX() ? 44 : 20) : StatusBar.currentHeight;

// export default {
//   MESSAGE_BAR_HEIGHT,
//   BOTTOM_SPACING,
//   SIDE_MENU_BOTTOM_SPACING,
//   ratio,
//   scale,
//   scaleVertical,
//   screenWidth,
//   screenHeight,
//   generatedFontSize,
//   isIphoneX,
//   isKitKatAbove,
//   marginMinus: ratio(-10),
//   extraSmallMargin: ratio(4),
//   extraaSmallMargin: ratio(3),
//   smallMargin: ratio(8),
//   lineHeight: Platform.OS === 'ios' ? ratio(18) : ratio(23),
//   bigSmallMargin: ratio(12),
//   baseMargin: ratio(16),
//   mediumMargin: ratio(20),
//   largeMargin: ratio(24),
//   doubleBaseMargin: ratio(32),
//   bottomSpaceIphoneX: BOTTOM_SPACE_IPHONE_X,
//   statusBarHeightIos: STATUSBAR_HEIGHT_IOS,
//   statusBarHeight: STATUSBAR_HEIGHT,
//   navBarHeight,
//   navBarHeightWithoutStatus: NAVBAR_HEIGHT,
//   navBarHeightWithoutStatus2: NAVBAR_HEIGHT2,
//   tabBarHeight: ratio(49),
//   separatorHeight: ratio(1),

//   // app specific
//   multilineHeight: ratio(107),
//   imagesSwiperHeight: screenHeight * 0.42,
//   borderWidth: ratio(3),
//   borderRadius12: ratio(12),
//   borderRadius: ratio(10),
//   backdropOpacity: 0.4,
//   hitSlop,
// };
