import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: Metrics.height * 0.13,
    borderRadius: 20,
    overflow: 'hidden',
    marginBottom: Metrics.defaultMargin,
    justifyContent: 'center',
  },
  image: {
    height: '100%',
    width: '100%',
    position: 'absolute',
  },
  title: {
    fontSize: Metrics.largeFont,
    color: Colors.primary,
    textTransform: 'uppercase',
    fontFamily: Fonts.primaryBold,
    textAlign: 'center',
  },
});

export default styles;
