import Immutable from 'seamless-immutable';
import {NETWORK_INFO} from './types';

const initialState = Immutable({
  isNetworkConnected: false,
});

export default function networkInfo(state = initialState, action) {
  switch (action.type) {
    case NETWORK_INFO:
      return Immutable.merge(state, {
        isNetworkConnected: action.isNetworkConnected,
      });
    default:
      return state;
  }
}
