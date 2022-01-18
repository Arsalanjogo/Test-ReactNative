import Config from 'react-native-config';
import moment from 'moment';
import {IMAGE_BASE_URL} from '../Config/WebService';

let ID;
export function setUserId(_id) {
  ID = _id;
}

export function getUserId() {
  return ID;
}

let langTag;
export function setLanguageTag(ln) {
  langTag = ln;
}

export function getLanguageTag() {
  return langTag;
}

let token;
export function setToken(_token) {
  token = _token;
}

export function getToken() {
  return token;
}

export function concatImageUrl(url) {
  if (url) {
    if (url.includes('http')) {
      return url;
    } else {
      return `${IMAGE_BASE_URL}${url}`;
    }
  } else return null;
}

export const groupedDays = messages => {
  return messages.reduce((acc, el, i) => {
    const messageDay = moment(el.created_at).format('YYYY-MM-DD');
    if (acc[messageDay]) {
      return {...acc, [messageDay]: acc[messageDay].concat([el])};
    }
    return {...acc, [messageDay]: [el]};
  }, {});
};

export const generateItems = messages => {
  const days = groupedDays(messages);
  const sortedDays = Object.keys(days).sort(
    (x, y) => moment(y, 'YYYY-MM-DD').unix() - moment(x, 'YYYY-MM-DD').unix(),
  );
  const items = sortedDays.reduce((acc, date) => {
    const sortedMessages = days[date].sort(
      (x, y) => new Date(y.created_at) - new Date(x.created_at),
    );
    return acc.concat([...sortedMessages, {type: 'day', date, id: date}]);
  }, []);
  return items;
};

export const extractIds = (arr = []) => {
  return arr.map(i => i.id);
};

// const Regex = {
//   lowerCase: /^(?=.*[a-z])/,
//   upperCase: /^(?=.*[A-Z])/,
//   numeric: /^(?=.*[0-9])/,
//   special: /^(?=.*[!@#$%^&*])/,
//   alphaNumeric: /^([a-zA-Z0-9 _-]+)$/,
// };

export const hasLowerCase = str => {
  return /^(?=.*[a-z])/.test(str);
};

export const hasUpperCase = str => {
  return /^(?=.*[A-Z])/.test(str);
};

export const hasSpecialCharachter = str => {
  return /[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/.test(str);
};

export const hasNumber = str => {
  return /^(?=.*[0-9])/.test(str);
};

export const validateEmail = email => {
  var re =
    /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
};
