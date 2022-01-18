import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({

button: {
        marginVertical: Metrics.defaultFont,
        marginHorizontal:Metrics.defaultMargin
      },
      buttonIcon:{
        color:Colors.primary,
        fontSize:Metrics.largeMargin,
        marginRight: Metrics.smallMargin
      },
      toRow:{
        flexDirection:'row',
        justifyContent:'space-around',
        alignItems:'center',
        marginVertical: Metrics.defaultFont,

   
      },
      moreIcon:{
        color:'white',
        fontSize:40
      },
      sendButton:{
        marginHorizontal:0,
        width:'105%'
      }
});

export default styles;
