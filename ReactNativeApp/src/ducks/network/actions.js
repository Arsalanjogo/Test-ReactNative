// @flow

import {NETWORK_INFO} from './types';

export function networkInfoListener(isNetworkConnected: boolean = false) {
  return {
    isNetworkConnected,
    type: NETWORK_INFO,
  };
}
