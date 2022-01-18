import {fork} from 'redux-saga/effects';

import auth from './auth/saga';
import home from './home/saga';

export default function* root() {
  yield fork(auth);
  yield fork(home);
}
