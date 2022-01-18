import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  button: {
    marginHorizontal: Metrics.defaultMargin,
    marginVertical: Metrics.defaultMargin,
  },
  avatar: {
    height: 120,
    width: 120,
    borderRadius:60,
    alignSelf: 'center',
    marginVertical: '5%',
  },
  addText: {
    color: Colors.primary,
    alignSelf: 'center',
    fontFamily: Fonts.primaryBold,
  },
  whiteText: {
    color: 'white',
    fontFamily: Fonts.primary,
    fontSize: Metrics.defaultFont,
  },
  yellowText: {
    color: Colors.primary,
    fontFamily: Fonts.primary,
    fontSize: Metrics.defaultFont,
  },
  agreeView: {
    flexDirection: 'row',
    marginHorizontal: Metrics.defaultMargin,
  },
  box: {
    height: 25,
    width: 25,
    borderWidth: 1,
    borderColor: 'white',
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: Colors.darkGray,
    marginHorizontal: 10,
  },

  validationView: {
    marginVertical: Metrics.defaultMargin,
    marginLeft: Metrics.smallMargin,
  },
  validationTitle: {
    marginLeft: Metrics.defaultMargin,
    marginVertical: 6,
  },
  inputView: {
    marginTop: Metrics.defaultMargin,
  },
  dobInput: {
    fontSize: Metrics.defaultFont,
    borderRadius: Metrics.height * 0.04,
    backgroundColor: Colors.backgroundDark,
    textAlign: 'left',
    fontFamily: Fonts.primary,
    paddingHorizontal: 20,
    height: Metrics.height * 0.060,
    borderWidth: 1.5,
    borderColor: 'white',
    marginHorizontal: Metrics.defaultMargin,
    marginBottom: 25,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  dobLabel: {
    fontSize: Metrics.smallFont,
    fontFamily: Fonts.primaryBold,
    textTransform: 'uppercase',
    color: Colors.light,
    marginBottom: 3,
    marginLeft: Metrics.largeMargin,
  },
  cameraIconView:{
alignItems:'center',
justifyContent: 'center',
height:40,
width:40,
borderRadius:20,
backgroundColor:Colors.primary,
marginTop:-60,
marginLeft:80
  },
  cameraIcon:{
    alignSelf:'center'
  },
  topView:{
    justifyContent:'center',
    alignItems:'center'
  }
});

export default styles;
