import React, {useEffect, useState} from 'react';
import {View, StatusBar, Image, ImageBackground} from 'react-native';
import {Provider} from 'react-redux';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import {RootSiblingParent} from 'react-native-root-siblings';
import SplashScreen from 'react-native-splash-screen';

import CodePush from './Configuration/CodePush';
import NavigationContainer from './Navigation';
import DownloadUpdates from './Components/DownloadUpdate';
import {setI18nConfig} from './Translations';

import {ConfigureApp, DataHandler, Util, NetworkInfo} from './Utils';
import {MessageBar} from './Components';
ConfigureApp();
import configureStore from './Store';
import {networkActions} from './ducks/network';
import {TopLoader} from './Modals';
import {Images, Metrics} from './Theme';

const Splash = () => {
  return (
    <ImageBackground
      style={{
        alignItems: 'center',
        justifyContent: 'center',
        width: '100%',
        height: '100%',
      }}
      source={
        Util.isPlatformAndroid()
          ? {uri: 'launch_screen'}
          : Images.images.splashBackground
      }>
      <Image
        source={Images.images.splashLogo}
        style={{
          height: Metrics.height * 0.25,
          width: Metrics.width * 0.55,
        }}
        resizeMode="contain"
      />
    </ImageBackground>
  );
};

const App = props => {
  const {
    downloading = false,
    installing = false,
    receivedBytes,
    totalBytes,
    isMandatory = false,
    onClose = () => {},
  } = props;

  // set store state
  const [storeState, setStore] = useState(null);

  // when store is configured
  const onStoreConfigure = store => {
    // set store
    DataHandler.setStore(store);

    setTimeout(() => {
      setStore(store);
    }, 4200);

    // set network listener
    NetworkInfo.networkInfoListener(
      store.dispatch,
      networkActions.networkInfoListener,
    );

    // hide splash
    setTimeout(() => {
      SplashScreen.hide();
    }, 100);
  };

  useEffect(() => {
    setI18nConfig();
    // configure store
    configureStore(onStoreConfigure);

    if (Util.isPlatformAndroid()) {
      StatusBar.setBackgroundColor('rgba(0,0,0,0)');
      // StatusBar.setBarStyle('light-content');
      StatusBar.setTranslucent(true);
    }

    return () => {
      // remove network listener
      NetworkInfo.removeNetworkInfoListener(
        DataHandler.getStore(),
        networkActions.networkInfoListener,
      );
    };
  }, []);

  if (storeState === null) {
    return <Splash />;
  }

  return (
    <RootSiblingParent>
      <SafeAreaProvider>
        <View style={{flex: 1, backgroundColor: 'black'}}>
          <Provider store={storeState}>
            <NavigationContainer />
            <MessageBar />
            <TopLoader ref={ref => DataHandler.setTopLoaderRef(ref)} />
            <DownloadUpdates
              downloading={downloading}
              installing={installing}
              receivedBytes={receivedBytes}
              totalBytes={totalBytes}
              onClose={onClose}
              isMandatory={isMandatory}
            />
          </Provider>
        </View>
      </SafeAreaProvider>
    </RootSiblingParent>
  );
};

export default CodePush(App);
