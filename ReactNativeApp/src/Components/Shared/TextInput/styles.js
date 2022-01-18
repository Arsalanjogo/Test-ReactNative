import { StyleSheet } from 'react-native';
import { Colors, Metrics, Fonts } from '../../../Theme';

const { height } = Metrics;

export default StyleSheet.create({
  inputContainer: {
    marginBottom: 25,
    marginHorizontal: Metrics.defaultMargin,
  },

  inputStyle: borderColor => ({
    fontSize: Metrics.defaultFont,
    borderRadius: Metrics.height * 0.04,
    backgroundColor: Colors.backgroundDark,
    textAlign: 'left',
    fontFamily: Fonts.primary,
    paddingHorizontal: 20,
    height: Metrics.height * 0.060,
    color: Colors.light,
    borderWidth: 1.5,
    borderColor: 'white',
    width:'100%'
    
  }),
  labelContainer: {
    backgroundColor: 'transparent',
    marginBottom: 3,
    marginLeft: Metrics.defaultMargin,
  },
  focusedLabelStyle: {},
  labelStyle: {
    fontSize: Metrics.smallFont,
    fontFamily: Fonts.primaryBold,
    textTransform: 'uppercase',
    color: Colors.light,
  },
  errorField: {
    borderColor: Colors.error,
  },
  isRowContainer: {
    flexDirection: 'row',
  },
  errorMsg:{
    fontSize: Metrics.defaultFont,
    fontFamily: Fonts.primary,
    color: Colors.error,
    marginLeft:Metrics.defaultMargin,
    marginTop:5
  }

});
