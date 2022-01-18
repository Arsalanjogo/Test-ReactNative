import {Keyboard} from 'react-native';
import Toast from 'react-native-root-toast';
import {Colors} from '../Theme';

export default showToast = msg => {
  Keyboard.dismiss();
  Toast.show(msg, {
    backgroundColor: Colors.primary,
    textColor: 'black',
    opacity: 0.95,
    position: -60,
    shadowColor: Colors.lightBackground,
  });
};

