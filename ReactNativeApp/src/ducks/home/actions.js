import {HOME} from './types';

export function requestHome(
  payload,
  reset,
  isPullToRefresh = false,
  identifier,
  isResetData = false,
) {
  return {
    payload,
    isPullToRefresh,
    reset,
    identifier,
    isResetData,
    type: HOME.REQUEST,
  };
}

export function successHome(data, identifier, reset) {
  return {
    data,
    // page,
    identifier,
    reset,
    type: HOME.SUCCESS,
  };
}

export function failureHome(errorMessage, identifier) {
  return {
    errorMessage,
    identifier,
    type: HOME.FAILURE,
  };
}
