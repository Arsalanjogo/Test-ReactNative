import _ from 'lodash';
import {create} from 'apisauce';
import {
  API_LOG,
  API_TIMEOUT,
  // BASE_URL,
  REQUEST_TYPE,
} from '../Config/WebService';
import DataHandler from './DataHandler';
import {Navigator, Util} from '../Utils';

import {authSelectors, authActions} from '../ducks/auth';
import {AUTH_IDENTIFIER_VERIFY_SIGN_UP} from '../ducks/ActionTypes';

var timer;

// const api = create({
//   baseURL: BASE_URL.AUTH,
//   timeout: API_TIMEOUT,
// });

export async function callRequest(url, payload, headers = {}, parameter) {
  // get attributes from url

  const {base_url, type, access_token_required} = url;

  // set X-API-TOKEN
  if (access_token_required) {
    const token = authSelectors.getUserToken(DataHandler.getStore().getState());
    headers.Authorization = `Bearer ${token}`; // '71005f35-596d-447d-938e-3bded1c178eb';
  }

  const route =
    parameter && parameter !== '' ? url.route + '/' + parameter : url.route;

  // init header object
  const headerObject = {
    headers,
  };

  // init responseoc
  let response;
  // on type send request
  switch (type) {
    case REQUEST_TYPE.GET:
      response = await create({baseURL: base_url, timeout: API_TIMEOUT}).get(
        route,
        payload,
        headerObject,
      );
      break;
    case REQUEST_TYPE.POST:
      response = await create({baseURL: base_url, timeout: API_TIMEOUT}).post(
        route,
        payload,
        headerObject,
      );
      // console.log()
      break;
    case REQUEST_TYPE.DELETE:
      response = await create({baseURL: base_url, timeout: API_TIMEOUT}).delete(
        route,
        payload,
        headerObject,
      );
      break;
    case REQUEST_TYPE.PUT:
      response = await create({baseURL: base_url, timeout: API_TIMEOUT}).put(
        route,
        payload,
        headerObject,
      );
      break;
    case REQUEST_TYPE.PATCH:
      response = await create({baseURL: base_url, timeout: API_TIMEOUT}).patch(
        route,
        payload,
        headerObject,
      );
      break;
    default:
      response = await create({baseURL: base_url, timeout: API_TIMEOUT}).get(
        route,
        payload,
        headerObject,
      );
  }

  console.log('url', url);
  console.log('response', response);
  console.log('payload', payload);

  return handleResponse(response);
}

export function handleResponse(response) {
  // log web service response
  if (__DEV__ && API_LOG) {
  }

  return new Promise((resolve, reject) => {
    // network error  internet not working
    const isNetWorkError = response.problem === 'NETWORK_ERROR';
    // network error  internet not working
    const isClientError = response.problem === 'CLIENT_ERROR';
    // kick user from server
    const isKickUser = response.status === 403; //|| response.status === 401;
    // if response is valid
    const isResponseValid = response.ok && response.data;
    //  && response.data.message;

    if (isResponseValid) {
      resolve(response.data);
    } else if (isNetWorkError) {
      reject({
        message: 'Internet connection error.',
        statusCode: response.status,
      });
    } else if (isKickUser) {
      /* reject({
        message: response?.data?.message,
        statusCode: response.status,
      });
      ChatHelper.disconnectSocket(true);
      FirebaseUtils.removeAllNotifications();

      DataHandler.getStore().dispatch(authActions.successLogout());
      // DataHandler.getStore().dispatch(authActions.setGuestUser(true));
      setTimeout(() => {
        NavigationService.reset('Login');
        Util.showMessage(response?.data?.message);
      }, 500); */

      clearTimeout(timer);
      timer = setTimeout(() => {
        Navigator.reset('Login');

        reject({
          message: response?.data?.message,
          statusCode: response.status,
        });
        // ChatHelper.disconnectSocket(true);
        // FirebaseUtils.removeAllNotifications();

        DataHandler.getStore().dispatch(authActions.successLogout());
        // DataHandler.getStore().dispatch(authActions.setGuestUser(true));

        Util.showMessage(
          response?.data?.message ??
            'Your session has been expired. Please Re-Login',
        );
      }, 500);
    } else if (isClientError) {
      if (
        // response?.data?.message === 'Blocked' &&
        response?.data?.message === 'Unauthorized' &&
        response?.data?.data?.status === 0
      ) {
        Navigator.navigate('Verification', {
          user_id: response?.data?.data?.id,
          identifier: AUTH_IDENTIFIER_VERIFY_SIGN_UP,
        });
      }

      reject({
        message:
          response.data.message && _.isString(response.data.message)
            ? response.data.message
            : getMessage(response),
        statusCode: response.status,
      });
    } else {
      reject({
        message: getMessage(response),
        statusCode: response.status,
      });
    }
  });
}

function getMessage(response) {
  if (Util.isPlatformAndroid()) {
    return 'Something went wrong';
  }

  let message = '';

  if (typeof response.data === 'object') {
    message =
      response.data.message || response.data.exception || response.data.file;
  } else {
    message = response?.data?.message ?? '';
  }

  return `${response.status}: ${message}`;
}
