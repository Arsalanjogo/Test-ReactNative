const defaultValue = {};

export const getRequestFlag = key => store => {
  if (Array.isArray(key)) {
    console.log(key, 'key');
    let value = defaultValue;
    for (let i = 0; i < key.length; i += 1) {
      const keyI = key[i];
      if (store.requestFlags[keyI] && store.requestFlags[keyI].loading) {
        value = store.requestFlags[keyI];
        break;
      }
    }
    return value;
  }

  return store.requestFlags[key] ? store.requestFlags[key] : defaultValue;
};
