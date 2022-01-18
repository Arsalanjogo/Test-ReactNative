import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../../Theme';

const styles = StyleSheet.create({
  container: {
    height: Metrics.height * 0.06,
    borderRadius: Metrics.height * 0.04,
    alignItems: 'center',
    justifyContent: 'center',
    padding: Metrics.xsmallMargin,
    overflow: 'hidden',
    borderColor: Colors.primary,
    borderWidth: 1,
  },
  background: {
    padding: Metrics.defaultMargin,
    borderTopWidth: 0.5,
    borderColor: Colors.darkGray,
  },
  button: {
    height: '100%',
    width: '100%',
    justifyContent: 'center',
    flexDirection:'row',
    alignItems:'center'
  },
  buttonText: {
    fontSize: Metrics.mediumFont,
    textAlign: 'center',
    fontFamily: Fonts.primaryBold,
    textTransform: 'uppercase',
  },
  loader: {
    position: 'absolute',
    right: 10,
  },
});

export default styles;
