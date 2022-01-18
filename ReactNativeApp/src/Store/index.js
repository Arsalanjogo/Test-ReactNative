import autoMergeLevel2 from 'redux-persist/lib/stateReconciler/autoMergeLevel2';
import AsyncStorage from '@react-native-community/async-storage';
import createSagaMiddleware from 'redux-saga';
import {persistStore, persistReducer} from 'redux-persist';
import {composeWithDevTools} from 'remote-redux-devtools';
import {createStore, applyMiddleware} from 'redux';
import {createLogger} from 'redux-logger';
import {enableBatching} from 'redux-batched-actions';
import {whiteList} from '../Config/ReduxStorage';
import RootReducer from '../ducks/RootReducer';
import RootSaga from '../ducks/RootSaga';

// check if chrome debugger is on
const isDebuggingInChrome = __DEV__ && !!window.navigator.userAgent;

export default function configureStore(onComplete: Function) {
  // init logger
  const logger = createLogger({
    predicate: () => isDebuggingInChrome,
    collapsed: true,
    duration: true,
    diff: true,
  });

  // create the saga middleware
  const sagaMiddleware = createSagaMiddleware();

  // create list of middleware
  const middlewareList = [sagaMiddleware];

  if (__DEV__) {
    // if dev push logger middle ware
    middlewareList.push(logger);
  }

  // init middleware with list
  const middleware = applyMiddleware(...middlewareList);

  // init persist config - set which reducers to save
  const persistConfig = {
    key: 'root',
    storage: AsyncStorage,
    whitelist: whiteList,
    stateReconciler: autoMergeLevel2,
  };

  // init redux persist reducer
  const persistedReducer = persistReducer(persistConfig, RootReducer);

  // create store with remote dev tools
  const composeEnhancers = composeWithDevTools({realtime: true});
  const store = createStore(
    enableBatching(persistedReducer),
    composeEnhancers(middleware),
  );

  // set store in window
  if (isDebuggingInChrome) {
    window.store = store;
  }

  // init store with redux persist
  persistStore(store, null, () => onComplete(store));

  // then run the saga
  sagaMiddleware.run(RootSaga);
}
