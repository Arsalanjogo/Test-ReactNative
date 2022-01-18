import {HOME} from './types';

const initialState = {
  posts: [],
};

export default (state = initialState, action) => {
  switch (action.type) {
    case HOME.SUCCESS: {
      console.log(action, 'what is coming');
      return {
        ...state,
        posts: action.data,
      };
    }

    default:
      return state;
  }
};
