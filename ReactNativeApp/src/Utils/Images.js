import {Image} from 'react-native';
export const Images = {
  Icons: {
    postLogo: require('../assets/Icons/postLogo/postLogo.png'),
    like: require('../assets/Icons/like/like.png'),
    comment: require('../assets/Icons/comment/comment.png'),
    share: require('../assets/Icons/share/share.png'),
  },
  GamesDummy: require('../../assets/images/GamesDummy.png'),
  GameBG: require('../../assets/images/GameBG.png'),
  splashBackground: require('../../assets/images/splashBackground.png'),
  splashLogo: require('../../assets/logo/splashLogo.png'),
  logoTransparent: require('../../assets/logo/logoTransparent.png'),
  home1: require('../../assets/images/Home1.png'),
  home2: require('../../assets/images/Home2.png'),
  home3: require('../../assets/images/Home3.png'),
  videoLoader: Image.resolveAssetSource(
    require('../../assets/images/videoLoader.gif'),
  ).uri,
  avatar: require('../../assets/images/avatar.png'),
  dummyVideo: require('../assets/videos/Juggling.mp4'),
  dummyVideo2: require('../assets/videos/SampleVideo.mp4'),
};
