import {StyleSheet} from 'react-native';
import {Metrics, Colors, Fonts} from '../../Theme';

const styles = StyleSheet.create({
  imageStyle: {
    width: Metrics.width,
    height: 450,
  },
  videoContainer: {
    height: 350,
    backgroundColor: Colors.backgroundLight,
    overflow: 'hidden',
    width: Metrics.width,
  },
  videoStyle: {
    height: 350,
  },
  itemStyle: {
    width: Metrics.width,
  },

  outerContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: Metrics.xsmallMargin,
    marginHorizontal: Metrics.defaultMargin,
    marginBottom: 0,
    alignItems: 'center',
  },
  paginationButtons: {
    alignSelf: 'flex-start',
  },
  iconContainer: {
    flexDirection: 'row',
    paddingRight: 0,
  },

  icon: {
    fontSize: Metrics.largeFont * 1.6,
  },
  iconLike: {
    fontSize: Metrics.largeFont * 1.6,
    marginRight: Metrics.xsmallMargin,
  },
  userStyle: {
    color: 'white',
    fontWeight: 'bold',
    marginLeft: Metrics.xsmallMargin,
    fontSize: 12,
    fontFamily: Fonts.primary,
    textAlign: 'center',
  },
  // slideDefault: {
  //     flex: 1,
  //     justifyContent: 'center',

  //     alignItems: 'center',
  //     backgroundColor: '#9DD6EB'
  // }
});

export default styles;
