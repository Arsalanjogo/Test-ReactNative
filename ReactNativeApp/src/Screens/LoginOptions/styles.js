import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  logo: {
    height: 88,
    width: 88,
    alignSelf: 'center',
    marginTop: '25%',
    marginBottom: '5%',
  },
  socialButton: {
    flexDirection: 'row',
    width: '90%',
    height: Metrics.height * 0.060,
    borderRadius: Metrics.height * 0.04,
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'center',
    backgroundColor: 'white',
    marginVertical: 10,
  },
  firstView: {
    width: '30%',
    alignItems: 'center',
  },
  secondView: {
    width: '70%',
  },
  socialIcon: {
    height: 40,
    width: 30,
  },
  titleView: {
    marginVertical: Metrics.smallMargin,
  },
  screenTitle: {
    fontFamily: Fonts.primaryBold,
    alignSelf: 'center',
    fontSize: Metrics.mediumFont,
  },
  createButton: {
    width: '90%',
    alignSelf: 'center',
  },
  loginTitleView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'center',
    marginVertical: 10,
  },
  loginText: {
    color: Colors.primary,
    marginLeft: 5,
  },
});

export default styles;
