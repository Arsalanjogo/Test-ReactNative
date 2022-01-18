import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  title: {
    fontFamily: Fonts.primaryBold,
    fontSize: Metrics.mediumFont,
    marginVertical: 10,
  },
  details: {
    fontSize: Metrics.mediumFont,
  },
  container: {
    marginHorizontal: Metrics.defaultMargin,
  },
});

export default styles;
