import React from 'react';
import { Provider } from 'react-redux';
import { createStore, compose, applyMiddleware } from 'redux';
import { persistStore, persistReducer } from 'redux-persist';
import { PersistGate } from 'redux-persist/lib/integration/react';
import AsyncStorage from '@react-native-community/async-storage';
import thunk from 'redux-thunk';
import SplashScreen from 'react-native-bootsplash';
import { setConfig } from '../Services/Configuration';
//Reducers
import AllReducers from '../Store';

const persistConfig = {
  key: 'root',
  storage: AsyncStorage,
  blacklist: ['feedPostReducer'],
  whitelist: ['userReducer'],
};

const persistedReducer = persistReducer(persistConfig, AllReducers);

const store = createStore(persistedReducer, compose(applyMiddleware(thunk)));

const persistor = persistStore(store, {}, () => {
  SplashScreen.hide({ fade: true });
  setConfig(store.getState().userReducer)
});

export default ConfigureStore = props => {
  return (
    <Provider store={store}>
      <PersistGate persistor={persistor}>{props.children}</PersistGate>
    </Provider>
  );
};
