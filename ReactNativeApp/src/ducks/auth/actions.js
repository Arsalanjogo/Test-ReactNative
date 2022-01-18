import {USER, LOGOUT} from './types';

export function requestUser(
  payload,
  identifier,
  url,
  callback = null,
  failureCallback = null,
) {
  return {
    payload,
    identifier,
    url,
    callback,
    failureCallback,
    type: USER.REQUEST,
  };
}

export function successUser(data, identifier) {
  return {
    data,
    identifier,
    type: USER.SUCCESS,
  };
}

export function failureUser(errorMessage, identifier) {
  return {
    errorMessage,
    identifier,
    type: USER.FAILURE,
  };
}

export function requestLogout(callback) {
  return {
    callback,
    type: LOGOUT.REQUEST,
  };
}

export function successLogout() {
  return {
    type: LOGOUT.SUCCESS,
  };
}

export function failureLogout(errorMessage) {
  return {
    errorMessage,
    type: LOGOUT.FAILURE,
  };
}
