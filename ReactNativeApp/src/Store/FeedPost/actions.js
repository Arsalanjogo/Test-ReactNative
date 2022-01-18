import {
  GET_POSTS,
  CONTROL_VOLUME,
  LOAD_MORE,
  SET_LIKE,
  CREATE_VIEW,
  POSTS_LOADING,
  SET_POSTS,
} from './types';
import { SET_LOADER } from '../Loader/types';
import { FeedApi } from '../../Services';
import { showToast } from '../../Utils';
const getPosts = offset => {
  return async dispatch => {
    dispatch({ type: POSTS_LOADING, payload: true });
    // dispatch({ type: GET_POSTS, payload: response.data });
    console.log(offset, 'offset');
    FeedApi.getPosts(offset)
      .then(res => res.json())
      .then(response => {
        console.log(response, "errrr")
        if (response.statusCode == 200) {
          dispatch({ type: GET_POSTS, payload: response.data });
          dispatch({ type: POSTS_LOADING, payload: false });
        }
      })
      .catch(err => {
        showToast(err);
        dispatch({ type: POSTS_LOADING, payload: false });
      });

    // dispatch({ type: GET_POSTS });
  };
};
const setPosts = () => {
  return {
    type: SET_POSTS
  }
}
const controlVolume = mute => {
  return {
    type: CONTROL_VOLUME,
    payload: mute,
  };
};
const setLike = (like, postId) => {
  return async dispatch => {
    dispatch({
      type: SET_LIKE,
      payload: { isLiked: like, postId },
    });
    FeedApi.setLike(postId)
      .then(res => res.json())
      .then(response => {
        console.log(response);
      })
      .catch(err => {
        showToast(err);
      });
  };
};
const createView = postId => {
  return async dispatch => {
    FeedApi.createView(postId)
      .then(res => res.json())
      .then(response => {
        // console.log(response);
        if (response?.statusCode == 200) {
          dispatch({ type: CREATE_VIEW, payload: { postId } });
        }
      })
      .catch(err => {
        showToast(err);
      });
  };
};
const setLoadMore = (loadMore, id) => {
  return {
    type: LOAD_MORE,
    payload: { loadMore, id },
  };
};

export { getPosts, controlVolume, setLoadMore, setLike, createView, setPosts };