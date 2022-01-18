import {FeedURL, headers} from './Configuration';

const FeedApi = {
  getPosts: from => {
    console.log(from, 'frommmm');
    return fetch(`${FeedURL}v1/posts?limit=${10}&from=${from}`, {
      method: 'GET',
      headers: headers,
    });
  },
  setLike: id => {
    // console.log(id, "likesss")
    return fetch(`${FeedURL}v1/posts/like-&-unlike?postId=${id}`, {
      method: 'GET',
      headers: headers,
    });
  },
  createView: id => {
    return fetch(`${FeedURL}/v1/posts/create-view?postId=${id}`, {
      method: 'GET',
      headers: headers,
    });
  },
};
export default FeedApi;
