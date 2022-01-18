import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  titleView: {
    marginHorizontal: Metrics.defaultMargin,
    alignSelf: 'center',
    marginVertical: Metrics.defaultMargin,
  },
  title: {
    alignSelf: 'center',
    textAlign:'center'
  },
  
  title2: {
    alignSelf: 'center',
    textAlign:'center',
    marginVertical:Metrics.defaultMargin
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
  inputView:{
    marginTop:Metrics.defaultFont
  },
  notReceivedView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'center',
    marginVertical: Metrics.largeMargin,
  },
  resendText: {
    color: Colors.primary,
    marginLeft: 5,
  },
});

export default styles;
