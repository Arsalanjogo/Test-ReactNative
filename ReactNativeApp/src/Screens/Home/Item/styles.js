import {StyleSheet} from 'react-native';

import {Metrics} from '../../../Theme';

export default StyleSheet.create({
  container: {
    marginVertical: Metrics.ratio(10),
  },
  logoContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: Metrics.ratio(9),
    marginHorizontal: Metrics.ratio(16),
  },
  logo: {
    marginRight: Metrics.ratio(9),
  },
  dot: {
    width: Metrics.ratio(8),
    height: Metrics.ratio(8),
    borderRadius: Metrics.ratio(4),
    marginRight: Metrics.ratio(8),
  },
  likeCommentContainer: {
    flexDirection: 'row',
    paddingVertical: Metrics.ratio(13),
    marginHorizontal: Metrics.ratio(16),
    alignItems: 'center',
  },
  like: {
    marginRight: Metrics.ratio(16),
  },
  dotsContainer: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
  },
  totalLikesViewsContainer: {
    flexDirection: 'row',
    marginVertical: Metrics.ratio(8),
  },
  likesViewsSeparator: {
    width: 1,
    backgroundColor: 'white',
    marginHorizontal: 8,
  },
  viewComments: {
    marginVertical: Metrics.ratio(4),
  },
  timeAgo: {
    marginTop: Metrics.ratio(4),
  },
  desc: {
    marginBottom: Metrics.ratio(4),
  },
  bottomContainer: {
    marginHorizontal: Metrics.ratio(16),
  },
});
