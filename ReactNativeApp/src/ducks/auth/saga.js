import {takeLatest, put, call} from 'redux-saga/effects';
import {Util} from '../../Utils';
import {USER, LOGOUT} from './types';
// import {API_USER_LOGOUT} from '../../config/WebService';
import {
  successUser,
  failureUser,
  successLogout,
  failureLogout,
} from './actions';
import {homeActions} from '../home';
import {
  AUTH_IDENTIFIER_LOGIN,
  AUTH_IDENTIFIER_LOGIN_SOCIAL,
} from '../ActionTypes';
import {callRequest} from '../../Utils/ApiSauce';
import {IDENTIFIERS} from '../../Config/Constants';
import {AuthApi} from '../../Services';
import {API_HOME_LISTING} from '../../Config/WebService';

function* userWatcherRequest(action) {
  const {payload, identifier, url, callback, failureCallback} = action;
  try {
    const response = yield call(callRequest, url, payload);

    if (response && response) {
      yield put(successUser(response?.result, identifier));
      if (callback) {
        callback(response.data || {}, response.message || '');
      }
    }
  } catch (err) {
    yield put(failureUser(err, identifier));
    if (
      identifier === AUTH_IDENTIFIER_LOGIN_SOCIAL &&
      err.message === 'Incorrect email or password.'
    ) {
    } else {
      Util.showMessage(err.message);
    }
    if (failureCallback) {
      failureCallback(err);
    }
  }
}

function* userLogoutRequest(action) {
  const {callback} = action;

  try {
    const response = yield call(callRequest, `${AuthApi}/logout`);
    if (response) {
      yield put(successLogout());
      if (callback) {
        callback();
      }
    }
    // FirebaseUtils.removeAllNotifications();
  } catch (err) {
    yield put(failureLogout(err));
    Util.showMessage(err.message);
  }
}

export default function* root() {
  yield takeLatest(USER.REQUEST, userWatcherRequest);
  yield takeLatest(LOGOUT.REQUEST, userLogoutRequest);
}
