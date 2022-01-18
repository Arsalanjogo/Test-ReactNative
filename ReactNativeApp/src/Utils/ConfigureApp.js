import {Text, StatusBar, LogBox, TextInput, Platform} from 'react-native';

import {
  allowTextFontScaling,
  allowIQKeyboardManager,
  allowIQKeyboardManagerToolbar,
} from '../Config/AppConfig';

import {Util, IQKeyboardManager} from '.';
import {Colors} from '../Theme';

export default () => {
  if (__DEV__) {
    //  eslint-disable-next-line no-console
    LogBox.ignoreAllLogs(true);
  }
  // FirebaseUtils.configure();
  if (Util.isPlatformIOS()) {
    // Allow IQKeyboardManager
    IQKeyboardManager.setEnable(allowIQKeyboardManager);

    // Allow Button IQKeyboardManager
    IQKeyboardManager.setToolbarPreviousNextButtonEnable(
      allowIQKeyboardManagerToolbar,
    );
  }

  if (Util.isPlatformAndroid()) {
    StatusBar.setTranslucent(true);
    StatusBar.setBarStyle('dark-content');
  }

  // Allow/disallow font-scaling in app
  Text.defaultProps = Text.defaultProps || {};
  Text.defaultProps.allowFontScaling = allowTextFontScaling;
  TextInput.selectionColor =
    Platform.OS === 'ios' ? Colors.primary : Colors.primary2;
};
