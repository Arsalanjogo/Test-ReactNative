import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../../Theme';

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    height: Metrics.height * 0.06,
    borderBottomWidth: 0.5,
    borderColor: Colors.darkGray,
  },
  absoluteContainer: {
    flexDirection: 'row',
    paddingHorizontal: 25,
    alignItems: 'center',
    justifyContent: 'space-between',
    height: Metrics.height * 0.1,
    position: 'absolute',
    zIndex: 100,
  },
  sideContainer: {
    width: '15%',
    height: '100%',
    justifyContent: 'center',
  },
  iconView: {
    width: Metrics.width * 0.15,
    height: Metrics.width * 0.15,
    borderRadius: Metrics.width * 0.1,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  icon: {
    tintColor: 'white',
    fontSize: Metrics.largeFont * 1.6,
  },
  textView: {
    width: '70%',
    alignItems: 'center',
    paddingHorizontal: Metrics.defaultMargin,
  },
  title: {
    fontFamily: Fonts.primaryBold,
    fontSize: Metrics.mediumFont,
    textAlign: 'center',
  },
  textInput: {
    width: '70%',
    height: '100%',
    fontSize: Metrics.mediumFont,
    color: Colors.placeholder,
    paddingLeft: '1%',
  },
});

export default styles;
