import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  modalButton:{
    height: Metrics.height * 0.060,
    backgroundColor: Colors.darkGray2,
    justifyContent:'center',
    width:Metrics.width /1.03,
    justifyContent:'center',
    marginBottom:Metrics.xsmallMargin,
    borderRadius:15,
    alignItems:'center'
  },
  modalButtonText:{
    fontFamily:Fonts.primaryMedium,
    color:Colors.light,
    fontSize:Metrics.largeFont
  },
  redText:{
    fontFamily:Fonts.primaryMedium,
    color:Colors.error,
    fontSize:Metrics.largeFont
  },
  buttonView:{
    marginBottom:Metrics.largeMargin
  }
});

export default styles;
