import {Platform} from 'react-native';
import {PERMISSIONS} from 'react-native-permissions';

export const IS_PRODUCTION = true;

export const DATE_FORMAT = 'YYYY-MM-DD';
export const TIME_FORMAT = 'HH-mm';
export const DATE_FORMAT_DISPLAY = 'D MMM, YYYY';
export const TIME_FORMAT_DISPLAY = 'h:mm A';
export const DATE_FORMAT_DISPLAY2 = 'D MMMM YYYY';
export const DATE_FORMAT_DISPLAY3 = 'MM-DD-YYYY';

export const STRIPE_MIN_AGE = 13;

export const CHAT_DATE_FORMAT = 'YYYY-MM-DD HH:mm:ss';
export const TIME_FORMAT_DISPLAY_CHAT = 'h:mm A';

export const OTP_RESEND_TIMER = 60;
export const VERIFY_CODE_COUNT = 4;
export const MIN_PRICE_LIMIT = IS_PRODUCTION ? 10 : 1;

// STRIPE KEY
export const STRIPE_PUBLISHABLE_KEY = IS_PRODUCTION
  ? 'pk_live_51IzltdCcaV1ArKdiK8rM1l6lH8awLtsa75P2BEQjqJcMVSpn9ug79RzDsy1Pjqq7IMxwlPhwuWNvDiCCv0ENdZxJ00L52FeB9n'
  : 'pk_test_51IxUHJGlEsPHBJQ8ukhI6sIN6V8mguRlnswZKRvupG7akV68LEJ6fstPVzvN1Ub0bIJeXA0xi7JjtgPsC3RdsxGd00cJTyhqbj';

export const FILE_TYPE = {
  VIDEO: 'mp4',
};

export const GOOGLE_API_KEY = 'AIzaSyAqKCBwCP1MPZFJKEDnlqVcFPOMM5Hbejs'; // 'AIzaSyA5UK72INdLzG3sd1C2ALvVMxez9pflwTw';

export const DATEPICKER_MODE = {
  DATE: 'date',
  TIME: 'time',
};

export const DATE_PICKER_TYPE = {
  DATE: 'date',
  TIME: 'time',
  DATE_TIME: 'datetime',
};
export const MEDIA_PICKER_TYPE = {
  DOC: 'DOC',
  MEDIA_WITH_DOC: 'MEDIA_WITH_DOC',
  MEDIA: 'MEDIA',
};
export const IMAGE_COMPRESS_MAX_WIDTH = 720;
export const PICKER_TYPE = {
  // FOR CAMERA
  CAMERA: 'CAMERA',
  CAMERA_WITH_CROPPING: 'CAMERA_WITH_CROPPING',
  CAMERA_BINARY_DATA: 'CAMERA_BINARY_DATA',
  CAMERA_WITH_CROPPING_BINARY_DATA: 'CAMERA_WITH_CROPPING_BINARY_DATA',

  // FOR GALLERY
  GALLERY: 'GALLERY',
  GALLERY_WITH_CROPPING: 'GALLERY_WITH_CROPPING',
  GALLERY_BINARY_DATA: 'GALLERY_BINARY_DATA',
  GALLERY_WITH_CROPPING_BINARY_DATA: 'GALLERY_WITH_CROPPING_BINARY_DATA',

  // FOR MULTI PICK
  MULTI_PICK: 'MULTI_PICK',
  MULTI_PICK_BINARY_DATA: 'MULTI_PICK_BINARY_DATA',
};

export const DOCUMENT_MIME_ANDROID = {
  PDF: 'application/pdf',
  // XLS: 'application/vnd.ms-excel',
  // XLSX: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  // CSV: 'text/csv',
};

export const MY_PERMISSIONS = {
  CAMERA: Platform.select({
    ios: PERMISSIONS.IOS.CAMERA,
    android: PERMISSIONS.ANDROID.CAMERA,
  }),
};

export const DOCUMENT_MIME_IOS = {
  PDF: 'com.adobe.pdf',
  // XLS: 'com.microsoft.excel.xls',
  // XLSX: 'com.microsoft.excel.xlsx',
  // CSV: 'com.microsoft.excel.csv',
};

export const RESEND_TIMER = 30;
export const NAME_MAX_LENGTH = 20;
export const USERNAME_MAX_LENGTH = 20;
export const PASSWORD_MAX_LENGTH = 16;

export const CONTENT_TYPE = {
  POLICIES: 'policies',
  ABOUT: 'about',
  LEGAL_AND_PRIVACY: 'legal-and-privacy',
  SUBSCRIPTIONS: 'subscription-works',
  TERMS_OF_USE: 'terms-of-use',
};

export const BUTTON_TYPE = {
  PURPLE: 1,
  WHITE: 2,
  GREY_BORDER: 3,
};

export const SOCIAL_LOGIN_TYPE = {
  FACEBOOK: 'facebook',
  GMAIL: 'gmail',
  APPLE: 'apple',
};

export const POST_TYPES = {
  MATING: 1,
  SELLING: 2,
};
export const SETTING_ITEM_TYPE = {
  DEFAULT: 1,
  ARROW: 2,
  TOGGLE: 3,
};

export const USER_DETAIL_TYPE = {
  PRIMARY: 1,
  SECONDARY: 2,
};

export const COUNTRY_CODE = '+1';
export const MEDIA_PICK_LIMIT = {
  SUBSCRIBED: 10,
  UNSUBSCRIBED: 5,
};
export const VIDEO_MAX_LENGTH = 30000;

export const ORDER_STATUS = {
  PENDING: 'Pending',
  DELIVERED: 'Delivered',
  PROCESSING: 'Processed',
  DISPUTED: 'Disputed',
  SOLD: 'Sold',
  PLACED: 'Placed',
  COMPLETED: 'Completed',
  ORDERED: 'Ordered',
};

export const ORDER_HISTORY_TYPE = {
  BOUGHT: 'BOUGHT',
  SOLD: 'SOLD',
};

export const RATING_TYPE = {
  RATING_INPUT: 1,
  RATING_WITH_COUNT: 2,
  RATING_WITHOUT_COUNT: 3,
  RATING_INPUT_WITH_TEXT: 4,
};

export const STAR_SIZE = {
  SMALL: 15,
  MEDIUM: 19,
  LARGE: 25,
  XLARGE: 36,
  XXLARGE: 40,
};

export const IDENTIFIERS = {
  HOME_LISTING: 'HOME_LISTING',
  MY_PRODUCT: 'MY_PRODUCT',
  FAVOURITE_PRODUCT: 'FAVOURITE_PRODUCT',
  SEARCH_PRODUCT: 'SEARCH_PRODUCT',
  DASHBOARD_PRODUCT: 'DASHBOARD_PRODUCT',
  CHAT_PRODUCTS: 'CHAT_PRODUCTS',
  USER_PRODUCTS: 'USER_PRODUCTS',
};
