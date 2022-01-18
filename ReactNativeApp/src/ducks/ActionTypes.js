// @flow
export const REQUEST = 'REQUEST';
export const SUCCESS = 'SUCCESS';
export const FAILURE = 'FAILURE';
export const CANCEL = 'CANCEL';
export const RESET = 'RESET';

export const defaultTypes = [REQUEST, SUCCESS, FAILURE, CANCEL, RESET];

//ACTION TYPES

// auth
export const AUTH_IDENTIFIER_LOGIN = 'login';
export const AUTH_IDENTIFIER_LOGIN_SOCIAL = 'social';

export const AUTH_IDENTIFIER_LOGOUT = 'logout';
export const AUTH_IDENTIFIER_SIGN_UP = 'signup';
export const AUTH_IDENTIFIER_FORGOT = 'forgot';

export const AUTH_IDENTIFIER_VERIFY_SIGN_UP = 'verify_signup';
export const AUTH_IDENTIFIER_VERIFY_FORGOT = 'verify_forgot';

export const AUTH_IDENTIFIER_RESET = 'resetPassword';
export const AUTH_IDENTIFIER_SEND_VERIFICATION_EMAIL =
  'send_verification_email';
export const AUTH_IDENTIFIER_RESEND_VERIFICATION_EMAIL =
  'resend_verification_email';

export const AUTH_IDENTIFIER_VALIDATE_USERNAME = 'validate_username';
export const AUTH_IDENTIFIER_CHANGE_PASSWORD = 'changePassword';
export const AUTH_IDENTIFIER_UPDATE_PROFILE = 'update_profile';
export const AUTH_IDENTIFIER_SEND_VERIFICATION_PHONE =
  'send_verification_phone';
export const AUTH_IDENTIFIER_VERIFY_PHONE = 'verify_phone';

export default function createRequestTypes(base, types = defaultTypes) {
  const res = {};
  types.forEach(type => {
    res[type] = `${base}_${type}`;
  });
  console.log(res, 'ressss');
  return res;
}
