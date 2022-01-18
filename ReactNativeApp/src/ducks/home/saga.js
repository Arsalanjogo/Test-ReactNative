import {call, put, takeEvery} from 'redux-saga/effects';

import {successHome, failureHome} from './actions';
import {callRequest} from '../../Utils/ApiSauce';
import {HOME} from './types';
import {authSelectors} from '../auth';
import {DataHandler} from '../../Utils';
import {API_HOME_LISTING} from '../../Config/WebService';

function* watchHomeListingRequest(action) {
  const {payload, identifier, reset} = action;
  try {
    const response = yield call(callRequest, API_HOME_LISTING, payload);
    yield put(successHome(response.data, identifier, reset));
  } catch (err) {
    yield put(failureHome(err.message, identifier));
  }
}

export default function* root() {
  yield takeEvery(HOME.REQUEST, watchHomeListingRequest);
}
