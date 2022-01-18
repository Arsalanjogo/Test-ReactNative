import NetInfo from '@react-native-community/netinfo';

import DataHandler from './DataHandler';

class NetworkInfo {
  timer = null;
  unsubscribe = null;
  isFirstTime = true;

  networkInfoListener(dispatch, networkInfoAction) {
    this.unsubscribe = NetInfo.addEventListener(state => {
      if (this.timer) {
        clearTimeout(this.timer);
      }
      DataHandler.setInternetConnected(state.isConnected);
      this.timer = setTimeout(() => {
        dispatch(networkInfoAction(state.isConnected));

        if (this.isFirstTime) {
          this.isFirstTime = false;
        }
      }, 3000);
    });
  }

  removeNetworkInfoListener(dispatch, networkInfoAction) {
    if (this.unsubscribe) {
      this.unsubscribe();
    }
    this.isFirstTime = true;
    if (this.timer) {
      clearTimeout(this.timer);
    }
  }
}

export default new NetworkInfo();
