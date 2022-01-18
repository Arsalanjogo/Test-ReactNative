import { LOGOUT } from '../Auth/types';
import {
  GET_POSTS,
  CONTROL_VOLUME,
  LOAD_MORE,
  SET_LIKE,
  CREATE_VIEW,
  POSTS_LOADING,
  SET_POSTS
} from './types';
const initialState = {
  mute: true,
  posts: [],
  isLoading: false,
  isNew: true
};

const feedPostReducer = (state = initialState, action) => {
  switch (action.type) {
    case GET_POSTS:
      console.log(state.posts.length, "statttt")
      let checkNew = true;
      if (!action.payload.length > 0)
        checkNew = false
      return { ...state, posts: [...state.posts, ...action.payload], isNew: checkNew };
    case SET_POSTS:
      return { ...state, posts: [] }
    case CONTROL_VOLUME:
      return { ...state, mute: action.payload };
    case SET_LIKE:
      // console.log("helloo")
      const _post = state.posts.map(post => {
        if (post.id == action.payload.postId) {
          post.isLiked = action.payload.isLiked;
          if (action.payload.isLiked) {
            post.totalLikes = post.totalLikes + 1;
          } else {
            post.totalLikes = post.totalLikes - 1;
          }
        }
        return post;
      });
      // console.log(_post)
      return { ...state, posts: _post };
    case LOAD_MORE:
      return state;
    case POSTS_LOADING:
      return { ...state, isLoading: action.payload };
    case LOGOUT:
      return { ...state, posts: [] }
    case CREATE_VIEW:
      const _postView = state.posts.map(post => {
        if (post.id == action.payload.postId) {
          post.totalViews = post.totalViews + 1;
        }
        return post;
      });
      // console.log(_postView, "posttvIee")
      return { ...state, posts: _postView };
    default:
      return state;
  }
};

export default feedPostReducer;