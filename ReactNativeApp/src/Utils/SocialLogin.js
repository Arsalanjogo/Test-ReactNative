import {Platform} from 'react-native';
// google
export const googleProfileRequestConfig = {
  scopes: [],
  iosClientId:'320074356626-o0ii2ji1525bgnqmsoat916f8mhhpqpf.apps.googleusercontent.com',
  androidClientId:'320074356626-ukg0jjsbu796iqvlnbcptarc6hhn8fr7.apps.googleusercontent.com',
  webClientId:
    Platform.OS === 'ios'
      ? '320074356626-o0ii2ji1525bgnqmsoat916f8mhhpqpf.apps.googleusercontent.com'
      : '320074356626-ukg0jjsbu796iqvlnbcptarc6hhn8fr7.apps.googleusercontent.com'
};
