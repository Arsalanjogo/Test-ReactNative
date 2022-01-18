import {USER} from './types';

import {AUTH_IDENTIFIER_LOGIN, AUTH_IDENTIFIER_LOGOUT} from '../ActionTypes';

const initialState = {
  data: {},
};

export default (state: Object = initialState, action: Object) => {
  switch (action.type) {
    case USER.SUCCESS: {
      if (action.identifier === AUTH_IDENTIFIER_LOGIN) {
        return {
          ...state,
          data: {...state.data, ...action.data},
        };
      }
      if (action.identifier === AUTH_IDENTIFIER_LOGOUT) {
        return initialState;
      }
      return state;
    }

    default:
      return state;
  }
};
