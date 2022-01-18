import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({

    tabBar:{
      alignItems:'center',
      flexDirection:'row',
      width:Metrics.width,
      justifyContent:'center'
    },
    button: {
        marginVertical: Metrics.defaultFont,
        marginHorizontal:Metrics.defaultMargin
    },
    tabHeading: {
      fontFamily:Fonts.primaryBold,
    },
    tabItem:{
      width:Metrics.width/2,
      alignItems:'center',
      height: Metrics.height * 0.06,
      justifyContent:'center'
    }
});

export default styles;
