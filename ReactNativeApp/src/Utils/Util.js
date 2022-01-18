import {getFocusedRouteNameFromRoute} from '@react-navigation/native';
import {MessageBarManager} from 'react-native-message-bar';
import {Platform, StatusBar, Alert, Linking} from 'react-native';
import moment from 'moment';
import _ from 'lodash';
import {normalize, schema} from 'normalizr';

import {DATE_FORMAT} from '../Config/Constants';

import {strings} from './i18n';

function stringToDateObject(date, format) {
  if (date === '') {
    return new Date();
  }
  return moment(date, format).toDate();
}

function isPlatformAndroid() {
  return Platform.OS === 'android';
}

function isPlatformIOS() {
  return Platform.OS === 'ios';
}

function getPlatform() {
  return Platform.OS;
}

function isEmpty(data) {
  return _.isEmpty(data);
}

function formatDate(dateString, currentDateFormat, formattedDateFormat) {
  return moment(dateString, currentDateFormat).format(formattedDateFormat);
}

function formatDate2(dateString, formattedDateFormat) {
  return moment(dateString).format(formattedDateFormat);
}

function formatTime(time, outputFormat = 'hh:mm A', defaultValue = '00:00') {
  return time && time !== '' ? moment(time).format(outputFormat) : defaultValue;
}

function getCurrentDate(format = DATE_FORMAT) {
  return moment().format(format);
}

function getDate(date, format = DATE_FORMAT) {
  return moment(date).format(format);
}

function showMessage(message, alertType = 'error', duration: 3000) {
  MessageBarManager.showAlert({
    message,
    alertType,
    duration,
  });
}

function getRandomNumber() {
  return Math.floor(Math.random() * 100000000000 + 1);
}

function getFormattedDateTime(dateTime, Format = 'YYYY-MM-DD', incomingFormat) {
  return incomingFormat
    ? moment(dateTime, incomingFormat).format(Format)
    : moment(dateTime).format(Format);
}

function getFormattedDateTime2(
  dateTime,
  Format = 'DD MMM YYYY',
  incomingFormat,
) {
  return incomingFormat
    ? moment(dateTime, incomingFormat).format(Format)
    : moment(dateTime).format(Format);
}
function getFormattedDateTime3(dateTime, Format = 'MMMM DD', incomingFormat) {
  return incomingFormat
    ? moment(dateTime, incomingFormat).format(Format)
    : moment(dateTime).format(Format);
}

function getDateDifferenceInDays(
  date1,
  date2,
  format = 'YYYY-DD-MM',
  unit = 'days',
) {
  const a = moment(date1, format);
  const b = moment(date2, format);
  console.log(a, b, 'a and b');
  return b.diff(a, unit);
}

function hideMessageBar() {
  try {
    MessageBarManager.hideAlert();
  } catch (error) {
    console.log('Error');
  }
}

function isNotEmpty(data) {
  return !_.isEmpty(data, true);
}

function clone(data) {
  return _.clone(data);
}

function cloneDeep(data) {
  return _.cloneDeep(data);
}

function compareDeep(previous, next) {
  return !_.isEqual(previous, next);
}

function setStatusBarStyle(barStyle) {
  StatusBar.setBarStyle(barStyle, true);
}

function showAlertConfirm(
  title,
  message,
  doneText,
  onDonePress,
  cancelText = 'Cancel',
) {
  Alert.alert(
    title,
    message,
    [
      {
        text: cancelText,
        onPress: () => {},
        style: 'cancel',
      },
      {text: doneText, onPress: () => onDonePress()},
    ],
    {cancelable: true},
  );
}

function getTypeAuth(identifier) {
  return `USER_${identifier}`;
}

function normalizeData(data, id = '_id') {
  const offerSchema = new schema.Entity('listItems', {}, {idAttribute: id});
  const offerListSchema = [offerSchema];
  const normalizedData = normalize(data, offerListSchema);
  return {
    ids: normalizedData.result,
    items: normalizedData.entities.listItems || {},
  };
}

function timeFromNow(time) {
  moment.updateLocale('en', {
    relativeTime: {
      future: 'in %s',
      past: '%s ago',
      s: 'a few seconds',
      ss: '%d seconds',
      m: 'a minute',
      mm: '%d minutes',
      h: 'an hour',
      hh: '%d hours',
      d: 'a day',
      dd: '%d days',
      M: 'a month',
      MM: '%d months',
      y: 'a year',
      yy: '%d years',
    },
  });

  return moment(time).fromNow();
}

function openStoreLink(
  id = Platform.select({android: 'com.puppymate', ios: '284882215'}),
) {
  let url = `itms-apps://itunes.apple.com/app/${id}`;

  if (Platform.OS === 'android') {
    url = `market://details?id=${id}`;
  }

  Linking.openURL(url)
    .then(() => {})
    .catch(err => {
      console.log('err:', err);
    });
}

export default {
  showMessage,
  isPlatformAndroid,
  isPlatformIOS,
  getPlatform,
  isEmpty,
  stringToDateObject,
  formatDate,
  getCurrentDate,
  getDate,
  isNotEmpty,
  clone,
  cloneDeep,
  compareDeep,
  formatDate2,
  getRandomNumber,
  getFormattedDateTime,
  getFormattedDateTime2,
  getFormattedDateTime3,
  getDateDifferenceInDays,
  hideMessageBar,
  formatTime,
  setStatusBarStyle,
  showAlertConfirm,
  getTypeAuth,
  normalizeData,
  timeFromNow,
  openStoreLink,
};
