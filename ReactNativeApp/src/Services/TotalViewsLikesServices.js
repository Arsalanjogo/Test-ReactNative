import { headers, FeedURL } from './Configuration';

const TotalViewsLikesApi = {
  getTotalLikes: id => {
    return fetch(
      `${FeedURL}v1/posts/liked-persons?postId=${id}&limit=10&from=0`,
      {
        method: 'GET',
        headers: headers,
      },
    );
  },
  searchUser: (id, value) => {
    return fetch(
      `${FeedURL}v1/posts/search-liked-persons?postId=${id}&search=${value}&limit=10&from=0`,
      {
        method: 'GET',
        headers: headers,
      },
    );
  },
  searchViewedUser: (id, value) => {
    return fetch(
      `${FeedURL}v1/posts/search-viewed-persons?postId=${id}&search=${value}&limit=10&from=${0}`,
      {
        method: 'GET',
        headers: headers,
      },
    );
  },
  getTotalViews: (id, offset = 0) => {
    return fetch(
      `${FeedURL}v1/posts/viewed-persons?postId=${id}&limit=10&from=${offset}`,
      {
        method: 'GET',
        headers: headers,
      },
    );
  },
};

export default TotalViewsLikesApi;
