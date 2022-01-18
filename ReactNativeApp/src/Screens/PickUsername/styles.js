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
    marginBottom:Metrics.xsmallMargin
  },
  button: {
    marginHorizontal: Metrics.defaultMargin,
    marginVertical: Metrics.buttonVerticalMargin,
  },
});

export default styles;
