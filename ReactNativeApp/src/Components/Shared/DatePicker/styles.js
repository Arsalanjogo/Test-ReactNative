import {StyleSheet} from 'react-native';
import {Colors, Metrics, Fonts} from '../../../Theme';

export default StyleSheet.create({
  dropdown: {
    backgroundColor: Colors.backgroundDark,
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 0,
    borderColor:'white',
    // height: Metrics.height * 0.06,
    borderRadius: 8,
    width:'10%',
    textAlign:'left'
    
  },
  dropdownText: {
    fontFamily: Fonts.primary,
    fontSize: Metrics.defaultFont,
    color: Colors.white,
    alignSelf:'flex-start',
    marginTop:Metrics.smallMargin
  },
  dropdownIcon: {
    // position: 'absolute',
    fontSize:25,
    marginLeft:'20%'
  },
  label: {
    fontSize: Metrics.defaultFont,
    fontFamily: Fonts.primary,
    textTransform: 'uppercase',
    marginBottom: Metrics.defaultMargin,
  },
  inputView: {
    // marginTop: Metrics.defaultMargin,
    borderWidth:2,
    borderColor:'white',
    width:222
  },
  dobInput: {
    fontSize: Metrics.defaultFont,
    borderRadius: Metrics.height * 0.04,
    backgroundColor: Colors.backgroundDark,
    // textAlign: 'left',
    fontFamily: Fonts.primary,
    paddingHorizontal: 20,
    height: Metrics.height * 0.060,
    borderWidth: 1.5,
    borderColor: 'white',
    marginHorizontal: Metrics.defaultMargin,
    marginBottom: 25,
    // flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width:'90%'
  },
  dobLabel: {
    fontSize: Metrics.smallFont,
    fontFamily: Fonts.primaryBold,
    textTransform: 'uppercase',
    color: Colors.light,
    marginBottom: 3,
    marginLeft: Metrics.largeMargin,
  },
});