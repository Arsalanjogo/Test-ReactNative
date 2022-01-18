import {RESULTS, request} from 'react-native-permissions';

export const checkPermission = permission => {
  return request(permission)
    .then(res => {
      switch (res) {
        case RESULTS.DENIED:
          return false;
        case RESULTS.GRANTED:
          return true;
        case RESULTS.BLOCKED:
          return false;
      }
    })
    .catch(err => console.log(err));
};
