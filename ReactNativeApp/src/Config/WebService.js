// DEV
export const BASE_URL = {
  AUTH: 'https://svf913jun1.execute-api.us-east-1.amazonaws.com/dev',
  FEED: 'https://g7nej3lm18.execute-api.us-east-1.amazonaws.com/dev',
};

// STAGING
// export const BASE_URL = {
//   AUTH: 'https://3itcmk3rd5.execute-api.us-east-1.amazonaws.com/staging/',
//   FEED: 'https://ux93r93q8c.execute-api.us-east-1.amazonaws.com/staging/',
// }

// PRE PRODUCTION
// export const BASE_URL = {
//   AUTH: '',
//   FEED: '',
// }

// PRODUCTION
// export const BASE_URL = {
//   AUTH: '',
//   FEED: '',
// }

// DEV IMAGE
export const IMAGE_BASE_URL = 'https://433-dev-files.s3.amazonaws.com/';

// STAGING IMAGE
// export const IMAGE_BASE_URL = 'https://433-staging-files.s3.amazonaws.com/';

// PRE PRODUCTION IMAGE
// export const IMAGE_BASE_URL = '';

// PRODUCTION IMAGE
// export const IMAGE_BASE_URL = '';

//
export const X_API_TOKEN = 'X-Access-Token';
export const WEB_URL = '';

// REQUEST TYPES
export const REQUEST_TYPE = {
  GET: 'get',
  POST: 'post',
  DELETE: 'delete',
  PUT: 'put',
  PATCH: 'patch',
};

export const LIMIT = 10;
export const API_TIMEOUT = 120000;
export const API = '/api/';
export const USER = '/user/';

export const API_LOG = true;

// API AUTH
export const API_USER_LOGIN = {
  base_url: BASE_URL.AUTH,
  route: `${API}auth/login`,
  access_token_required: false,
  type: REQUEST_TYPE.POST,
};

export const API_USER_LOGOUT = {
  base_url: BASE_URL.AUTH,
  route: `${API}auth/logout`,
  access_token_required: true,
  type: REQUEST_TYPE.GET,
};

// API FEED
export const API_HOME_LISTING = {
  base_url: BASE_URL.FEED,
  route: '/v1/posts',
  access_token_required: true,
  type: REQUEST_TYPE.GET,
};

// API USER ROUTES
// export const API_USER_SIGNUP = {
//   route: `${API}auth/signup`,
//   access_token_required: false,
//   type: REQUEST_TYPE.POST,
// };

// export const API_USER_SEND_VERIFICATION_CODE = {
//   route: `${API}auth/otp-verify`,
//   access_token_required: false,
//   type: REQUEST_TYPE.POST,
// };

// export const API_USER_RESEND_VERIFICATION_CODE = {
//   route: `${API}auth/resend-otp`,
//   access_token_required: false,
//   type: REQUEST_TYPE.POST,
// };

// export const API_USER_FORWARD_PASSWORD = {
//   route: `${API}auth/forgot-password`,
//   access_token_required: false,
//   type: REQUEST_TYPE.PATCH,
// };

// export const API_USER_RESET_PASSWORD = {
//   route: `${API}auth/update-password`,
//   access_token_required: false,
//   type: REQUEST_TYPE.PATCH,
// };

// export const API_USER_SOCIAL_LOGIN = {
//   route: `${API}auth/social-login`,
//   access_token_required: false,
//   type: REQUEST_TYPE.POST,
// };

// export const API_CONTACT_SUPPORT_SUBMISSION = {
//   route: `${API}auth/contact-support`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_USER_CHANGE_PASSWORD = {
//   route: `${API}auth/change-password`,
//   access_token_required: true,
//   type: REQUEST_TYPE.PATCH,
// };

// export const API_USER_UPDATE_PROFILE = {
//   route: `${API}auth/update-profile`,
//   access_token_required: true,
//   type: REQUEST_TYPE.PUT,
// };

// export const API_UPLOAD_FILE = {
//   // route: `${API}upload_spot_files`,
//   route: `${API}file/upload`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_GET_BREEDS = {
//   route: `${API}auth/breeds`,
//   access_token_required: false,
//   type: REQUEST_TYPE.GET,
// };

// UPLOAD_LOCATION
// export const API_UPLOAD_LOCATION = {
//   route: `${API}file/get-location-map-image`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// TOGGLE_NOTIFICATION
// export const API_TOGGLE_NOTIFICATION = {
//   route: `${API}auth/toggle-notification-setting`,
//   access_token_required: true,
//   type: REQUEST_TYPE.PATCH,
// };

// POST
// export const API_POST_LIST = {
//   route: `${API}v1/`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// PRODUCT
// export const API_PRODUCT_LIST = {
//   route: `${API}auth/posts`,
//   access_token_required: false,
//   type: REQUEST_TYPE.GET,
// };

// export const API_PRODUCT_ADD = {
//   route: `${API}auth/post`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_PRODUCT_EDIT = {
//   route: `${API}auth/post`,
//   access_token_required: true,
//   type: REQUEST_TYPE.PUT,
// };

// export const API_PRODUCT_DELETE = {
//   route: `${API}auth/post`,
//   access_token_required: true,
//   type: REQUEST_TYPE.DELETE,
// };

// export const API_PRODUCT_REPORT = {
//   route: `${API}auth/report-post`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_PRODUCT_LIKE_UNLIKE = {
//   route: `${API}auth/like-unlike-post`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_GET_BLOCKED_USERS = {
//   route: `${API}auth/blocked-users-list`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// export const API_POST_BLOCKED_USER = {
//   route: `${API}auth/block-unblock-user`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_DASHBOARD = {
//   route: `${API}auth/home`,
//   access_token_required: false,
//   type: REQUEST_TYPE.GET,
// };

// export const API_PRODUCT_ACTIVE_INACTIVE = {
//   route: `${API}auth/update-post-status`,
//   access_token_required: true,
//   type: REQUEST_TYPE.PATCH,
// };

// ORDER
// export const API_ORDER_LIST = {
//   route: `${API}auth/my-orders`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// export const API_ORDER_DETAIL = {
//   route: `${API}auth/order`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// CHECK_ORDER_STATUS
// export const API_CHECK_ORDER_STATUS = {
//   route: `${API}auth/check-payment-intent`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// DELETE_PAYMENT_INTENT
// export const API_DELETE_PAYMENT_INTENT = {
//   route: `${API}auth/delete-payment-intent`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// DISPUTES
// export const API_MY_DISPUTE = {
//   route: `${API}auth/dispute`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// export const API_ADD_DISPUTE = {
//   route: `${API}auth/addDispute`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// NOTIFICATIONS
// export const API_GET_NOTIFICATIONS_LIST = {
//   route: `${API}auth/user-notifications`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// export const API_GET_NOTIFICATIONS_COUNT = {
//   route: `${API}auth/user-notifications-count`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// export const API_POST_RESET_NOTIFICATIONS_COUNT = {
//   route: `${API}auth/user-notifications-read`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// REVIEWS
// export const API_REVIEWS_LIST = {
//   route: `${API}auth/reviews`,
//   access_token_required: false,
//   type: REQUEST_TYPE.GET,
// };

// export const API_ADD_REVIEW = {
//   route: `${API}auth/review-create`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_PLACE_ORDER = {
//   route: `${API}auth/order`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_CHANGE_ORDER_STATUS = {
//   route: `${API}auth/order-change-status`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_PAYMENT_INTENT = {
//   route: `${API}auth/payment_sheet`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_POST_CREATE_PAYMENT_ACCOUNT = {
//   route: `${API}auth/create-payment-account`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_GET_PAYMENT_ACCOUNT = {
//   route: `${API}auth/get-payment-account`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// export const API_POST_CHECK_BLOCK_STATUS = {
//   route: `${API}auth/check-block-status`,
//   access_token_required: true,
//   type: REQUEST_TYPE.POST,
// };

// export const API_GET_APP_SETTING = {
//   route: `${API}app-settings`,
//   access_token_required: false,
//   type: REQUEST_TYPE.GET,
// };

// API_GET_USER
// export const API_GET_USER = {
//   route: `${API}auth/user`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };

// REPORT_LISTING
// export const API_REPORT_LISTING = {
//   route: `${API}report-post-reasons`,
//   access_token_required: true,
//   type: REQUEST_TYPE.GET,
// };
