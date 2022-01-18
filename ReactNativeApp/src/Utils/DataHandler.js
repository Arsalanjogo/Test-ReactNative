let store;
let isInternetConnected = true;
let topLoaderRef = null;
let SliderImagesModalRef = null;

export default {
  setStore(value) {
    store = value;
  },

  getStore() {
    return store;
  },

  setSliderModalRef(ref) {
    SliderImagesModalRef = ref;
  },

  setTopLoaderRef(value) {
    topLoaderRef = value;
  },

  getTopLoaderRef() {
    return topLoaderRef;
  },

  getSliderModalRef() {
    return SliderImagesModalRef;
  },

  setInternetConnected(connected) {
    isInternetConnected = connected;
  },

  getIsInternetConnected() {
    return isInternetConnected;
  },
};
