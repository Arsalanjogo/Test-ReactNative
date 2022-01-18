import React, {useState, memo} from 'react';
import {connect} from 'react-redux';
import PostMedia from '../PostMedia';
import PostDetails from '../PostsDetail';
import {View} from 'react-native';

import styles from './styles';
function FeedsPost({item, isVisible}) {
  const [liked, setLiked] = useState(0);

  return (
    <View style={styles.postContainer}>
      <PostMedia
        post={item}
        isVisible={isVisible}
        liked={liked}
        setLiked={setLiked}
      />
      <PostDetails item={item} liked={liked} />
    </View>
  );
}
// const mapStateToProps = state => ({
//   videoVolumme: state.feedPostReducer.mute,
// });

// const mapDispatchToProps = dispatch => {
//   return {
//     getPosts: (...args) => {
//       dispatch(getPosts(...args));
//     },
//   };
// };

export default memo(FeedsPost);
