import {StyleSheet} from 'react-native';
import {Metrics} from '../../Theme';

export default StyleSheet.create({
  container: {
    justifyContent: 'center',
  },
  itemContainer: {
    width: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  paginationContainer: {
    right: 20,
    position: 'absolute',
    bottom: 40,
    justifyContent: 'center',
    flexDirection: 'row',
    alignItems: 'center',
  },
  imageStyle: {
    width: Metrics.width,
    height: Metrics.height * 0.42,
    borderTopLeftRadius: 0,
    borderTopRightRadius: 0,
    borderBottomLeftRadius: 44,
    borderBottomRightRadius: 44,
  },
  playButton: {
    alignSelf: 'center',
    position: 'absolute',
  },
});
