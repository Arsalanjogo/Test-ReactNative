import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'space-between',
  },
  infoContainer: {
    flex: 1,
    padding: Metrics.defaultMargin,
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
    marginBottom: Metrics.defaultMargin,
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
  buttonContainer: {
    padding: Metrics.defaultMargin,
    borderColor: Colors.darkGray,
    borderTopWidth: 0.5,
  },
  button: {
    marginBottom: Metrics.defaultMargin,
  },
  awardsView: {
    marginTop: 10,
  },
  awardText: {
    fontSize: Metrics.smallFont,
    fontFamily: Fonts.primaryBold,
    color: Colors.primary,
    marginBottom: 10,
    textTransform:'uppercase'
  },
});

export default styles;
