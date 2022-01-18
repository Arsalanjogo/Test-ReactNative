import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  image: {
    height: '70%',
    width: '100%',
    position: 'absolute',
  },
  container: {
    flex: 1,
    paddingTop: Metrics.height * 0.3,
  },
  infoContainer: {
    paddingHorizontal: Metrics.defaultMargin,
  },
  title: {
    color: Colors.primary,
    textTransform: 'uppercase',
    marginBottom: Metrics.defaultMargin,
  },
  videoContainer: {
    height: Metrics.height * 0.25,
    backgroundColor: Colors.backgroundLight,
    borderRadius: 20,
    overflow:'hidden'
  },
  description: {
    fontSize: Metrics.smallFont,
    lineHeight: Metrics.smallFont * 1.5,
    marginVertical: Metrics.defaultMargin,
  },
  heading: {
    color: Colors.primary,
    fontSize: Metrics.defaultFont,
    textTransform: 'uppercase',
  },
  score: {
    fontFamily: Fonts.primaryBold,
    fontSize: Metrics.largeFont,
  },
  video:{
    width:'100%',
    height:'100%'
  }
});

export default styles;
