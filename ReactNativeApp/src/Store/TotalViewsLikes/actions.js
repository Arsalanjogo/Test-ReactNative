// import { GET_LIKES_LISTING, LIKES_LOADING, GET_VIEWS_LISTING } from './types';
// import { TotalViewsLikesApi } from '../../Services';
// import { showToast } from '../../Utils';

// const getTotalLikes = postId => {
//   return async dispatch => {
//     dispatch({ type: LIKES_LOADING, payload: true });
//     TotalViewsLikesApi.getTotalLikes(postId)
//       .then(res => res.json())
//       .then(response => {
//         if (response.statusCode == 200) {
//           dispatch({ type: GET_LIKES_LISTING, payload: response.data });
//           dispatch({ type: LIKES_LOADING, payload: false });
//         }
//       })
//       .catch(err => {
//         showToast(err);
//         dispatch({ type: LIKES_LOADING, payload: false });
//       });
//   };
// };
// const getTotalViews = (postId, offset) => {
//   return async dispatch => {
//     dispatch({ type: LIKES_LOADING, payload: true });
//     TotalViewsLikesApi.getTotalViews(postId, offset)
//       .then(res => res.json())
//       .then(response => {
//         if (response.statusCode == 200) {
//           dispatch({ type: GET_VIEWS_LISTING, payload: response.data });
//           dispatch({ type: LIKES_LOADING, payload: false });
//         }
//       })
//       .catch(err => {
//         showToast(err);
//         dispatch({ type: LIKES_LOADING, payload: false });
//       });
//   };
// };

// export { getTotalLikes, getTotalViews };
