import Immutable from 'seamless-immutable';

import {REQUEST, SUCCESS, FAILURE, RESET} from '../ActionTypes';

const initialState = Immutable({});

const regularExpression = new RegExp(
  `(.*)_(${REQUEST}|${SUCCESS}|${FAILURE}|${RESET})`,
);

console.log(regularExpression, 'regularExpressionregularExpression');

export default (state: Object = initialState, action: Object) => {
  const {
    type,
    errorList,
    errorMessage,
    isPullToRefresh,
    reset,
    data,
    identifier,
    from,
    isResetData,
  } = action;
  console.log(identifier, 'identifieridentifieridentifieridentifier');
  const matches = regularExpression.exec(type);
  console.log(matches, 'matches');
  if (!matches) {
    return state;
  }

  const [, requestName, requestState] = matches;
  console.log(requestName, requestState, 'requestName, requestState');
  // const totalRecords = data instanceof Array ? data.length : 0;

  const requestIdentifier =
    identifier && identifier !== ''
      ? `${requestName}_${identifier}`
      : requestName;

  console.log(requestIdentifier, 'requestIdentifierrequestIdentifier');
  // const totalRecords = page && page.total ? page.total : 0;

  // const nextPage = page && page.current_page ? page.current_page + 1 : 0;

  let totalRecords = 0;
  if (from && from.totalDocs) {
    totalRecords = from.totalDocs;
  } else if (from && from.total) {
    totalRecords = from.total;
  } else if (
    state[requestIdentifier] &&
    state[requestIdentifier].totalRecords
  ) {
    totalRecords = state[requestIdentifier].totalRecords;
  }

  console.log(
    state[requestIdentifier],
    'state[requestIdentifier]state[requestIdentifier]state[requestIdentifier]',
  );

  const FROM =
    from && from.from
      ? from.from + 10
      : from && from.current_page
      ? from.current_page + 10
      : 10;

  if (isResetData) {
    return Immutable.merge(state, {
      [requestIdentifier]: {
        loading: true,
        failure: false,
        isPullToRefresh: false,
        reset: false,
        totalRecords: 0,
      },
    });
  }

  if (requestState === RESET) {
    return Immutable.merge(state, {
      [requestIdentifier]: {},
    });
  }

  let lastRecordsLength = 0;
  if (requestState === SUCCESS) {
    lastRecordsLength = data?.length ?? 0;
  } else if (
    state[requestIdentifier] &&
    state[requestIdentifier].lastRecordsLength
  ) {
    lastRecordsLength = state[requestIdentifier].lastRecordsLength;
  }

  return Immutable.merge(state, {
    [requestIdentifier]: {
      loading: requestState === REQUEST,
      failure: requestState === FAILURE,
      reset: reset || false,
      isPullToRefresh: isPullToRefresh || false,
      errorList: errorList || '',
      errorMessage: errorMessage || '',
      totalRecords,
      FROM,
      lastRecordsLength,
    },
  });
};
