import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  titleView: {
    marginHorizontal: Metrics.defaultMargin,
    alignSelf: 'center',
    marginVertical: Metrics.largeMargin,
    flexDirection: 'row',
    justifyContent: 'center',
  },
  title1: {},
  title2: {
    color: Colors.primary,
  },
  button: {
    marginHorizontal: Metrics.defaultMargin,
    marginVertical: Metrics.buttonVerticalMargin,
  },
  inputView: {
    marginTop: Metrics.largeMargin,
  },
});

export default styles;
