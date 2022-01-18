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
    width: '75%',
  },
  bottomControls: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    position: 'absolute',
    bottom: 0,
  },
  iconsView: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  controlIcons: {
    width: 34,
    height: 34,
    backgroundColor: 'rgba(0, 0, 0, 0.64)',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 16,
  },
  video: {
    // width: '100%',
    // height: '100%',
    position: 'absolute',
    top: 0,
    bottom: 0,
    right: 0,
    left: 0,
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
    left: 0,
  },
  fullScreenBottomControls: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    position: 'absolute',
    zIndex: 10,
    transform: [{rotate: '90deg'}],
    left: -Metrics.width / 1.5,
  },
  fullScreenSlider: {
    width: Metrics.height / 1.5,
  },
  timerContainer: {
    borderRadius: 8,
    backgroundColor: 'rgba(0, 0, 0, 0.64)',
    alignContent: 'center',
    alignItems: 'center',
    alignSelf: 'flex-end',
    textAlign: 'center',
    fontSize: Metrics.smallFont * 1.15,
    justifyContent: 'center',
    marginLeft: 'auto', // height: Metrics.height * 0.035,
    width: Metrics.width * 0.13,
    paddingVertical: 7,
  },
  activityIndicator: {
    position: 'absolute',
    top: 70,
    left: 70,
    right: 70,
    height: 50,
  },
});

export default styles;
