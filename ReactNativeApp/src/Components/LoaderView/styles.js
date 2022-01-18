// @flow
import {StyleSheet} from 'react-native';
import {Metrics} from '../../Theme';

export default StyleSheet.create({
  container: {
    top: 0,
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center',
    width: Metrics.width,
    height: Metrics.height,
  },
  loadingMessage: {
    marginBottom: 16,
  },
  modal: {
    margin: 0,
  },
});
