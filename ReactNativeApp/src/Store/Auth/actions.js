import {LOGIN, LOGOUT} from './types';

import {setConfig} from '../../Services/Configuration';

export const login = data => {
  return async dispatch => {
    if (data) setConfig(data);
    dispatch({
      type: LOGIN,
      payload: {...data},
    });
  };
};

export const logout = () => {
  return {
    type: LOGOUT,
  };
};
