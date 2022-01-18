import {combineReducers} from 'redux';

import auth from './auth';
import requestFlags from './requestFlags';
import home from './home';
import network from './network';

import {LOGOUT} from './auth/types';

const appReducer = combineReducers({
  auth,
  requestFlags,
  home,
  network,
});

export default (state, action) => {
  if (action.type === LOGOUT.SUCCESS) {
    const {home, network} = state;
    state = {
      network,
      home,
    };
  }
  return appReducer(state, action);
};
