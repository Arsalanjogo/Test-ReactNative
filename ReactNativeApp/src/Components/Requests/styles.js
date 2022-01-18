import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
    itemContainer : { 
        flexDirection:'row',
        justifyContent:'space-between',
        marginLeft:Metrics.xsmallMargin,
        alignItems:'center',
        marginVertical:Metrics.smallMargin
    },
    image : {
        height:64,
        width:64,
        borderRadius:32,
    }, 
    name: {
        fontFamily:Fonts.primaryBold,
        fontSize:Metrics.largeFont
    },
    userName: {
        fontFamily:Fonts.primaryMedium,
        fontSize:Metrics.defaultFont
    },
    crossIcon : {
        fontSize: Metrics.largeFont
    },
    
    nameView : {
        marginLeft:Metrics.xsmallMargin,
        paddingTop:Metrics.smallMargin
    },
    button: {
        height: Metrics.height * 0.045,
        width:'90%'
    },
    buttonTextStyle : {
        fontSize:Metrics.smallFont
    },
    rightView: {
        flexDirection:"row",
        width:'40%',
        alignItems:'center'
    },
    leftView: {
        flexDirection:"row",
        width:'60%'
    }, 
});

export default styles;
