import {BaseURL, headers} from './Configuration';

const AuthApi = {
  login: data => {
    return fetch(`${BaseURL}api/auth/login`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },
  
  register: data => {
    return fetch(`${BaseURL}api/auth/register`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },

  verifyUsername: data => {
    return fetch(`${BaseURL}api/auth/verify-username`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },

  validateEmail: data => {
    return fetch(`${BaseURL}api/auth/verify-email`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },


  resendEmailValidationCode: data => {
    return fetch(`${BaseURL}api/auth/resend-email-verification-token`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  }, 

  socialLogin: data => {
    return fetch(`${BaseURL}/api/auth/login-via-social`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },


  autoLogin: data => {
    return fetch(`${BaseURL}app/auto-login`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },

  requestPassword: data => {
    return fetch(`${BaseURL}api/auth/request-password`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },

  resetPassword: data => {
    return fetch(`${BaseURL}api/auth/reset-password`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },

  logOut: data => {
    let url = `${BaseURL}app/logout`;
    return fetch(url, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(data),
    });
  },

  checkUpdate: (version, type) => {
    return fetch(
      `${BaseURL}app/check-updates?current_version=${version}&device_type=${type}`,
      {
        headers: headers,
      },
    );
  },
};
export default AuthApi;
