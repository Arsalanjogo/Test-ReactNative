import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
card:{
    alignSelf:'center',
    justifyContent:'center',
    // marginHorizontal:Metrics.smallMargin
},
avatar:{
    height: 120,
    width: 120,
    borderRadius:60,
    alignSelf: 'center',
    marginVertical: '5%',
},
name:{
    color:Colors.primary,
    fontSize:Metrics.largeMargin,
    fontFamily:Fonts.primaryBold,
    textAlign:'center',
    marginVertical:Metrics.xsmallMargin
},
email:{
    color:Colors.textDisabled,
    textAlign:'center',
    fontFamily:Fonts.primaryBold,
    fontSize:Metrics.largeFont

},
description:{
    textAlign:'center',
    marginTop:Metrics.xsmallMargin,
    marginHorizontal: Metrics.defaultMargin,

},
friendsView:{
    flexDirection:'row',
    justifyContent:'center',
    alignItems:'center',
    marginVertical:Metrics.xsmallMargin
},
numberOfFriends:{
    fontFamily:Fonts.primaryBold,
    marginRight:Metrics.xsmallMargin,
    fontSize:Metrics.largeFont
},
friendsText:{

},
button: {
        marginVertical: Metrics.buttonVerticalMargin,
      },
});

export default styles;
