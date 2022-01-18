import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  titleView: {
    marginHorizontal: Metrics.defaultMargin,
    alignSelf: 'center',
    marginVertical: Metrics.largeMargin,
  },
  title: {
    alignSelf: 'center',
    textAlign:'center'
  },
  button: {
    marginHorizontal: Metrics.defaultMargin,
    marginVertical: Metrics.buttonVerticalMargin,
  },
  successImage: {
    height: 64,
    width: 64,
    alignSelf: 'center',
    marginVertical: Metrics.largeMargin,
  },
});

export default styles;
