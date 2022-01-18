import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  container: {},
  controlsView: {
    position: 'absolute',
    left: 15,
    right: 15,
    bottom: 10,
    top: 15,
    zIndex: 10,
    justifyContent: 'space-between',
  },
  slider: {
    height: 20,
    width: '80%',
  },
  bottomControls: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  iconsView: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  controlIcons: {
    width: 34,
    height: 34,
    backgroundColor: Colors.backgroundLight,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 5,
  },
  video: {
    width: '100%',
    height: '100%',
  },

  fullScreenView: {
    flex: 1,
    backgroundColor: Colors.backgroundDark,
    alignItems: 'center',
    justifyContent: 'center',
  },
  fullScreenVideo: {
    width: Metrics.height / 1.1,
    height: Metrics.height,
    transform: [{rotate: '90deg'}],
  },
  fullScreenIconsView: {
    position: 'absolute',
    flexDirection: 'row',
    zIndex: 10,
    justifyContent: 'space-between',
    transform: [{rotate: '90deg'}],
    width: Metrics.height / 1.15,
    left: 0
  },
  fullScreenBottomControls: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    position:'absolute',
    zIndex:10,
    transform: [{rotate: '90deg'}],
    left:-Metrics.width/1.5
  },
  fullScreenSlider: {
    width: Metrics.height/1.5,
  },
});

export default styles;
