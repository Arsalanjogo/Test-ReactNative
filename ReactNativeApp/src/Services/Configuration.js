import Config from 'react-native-config';

//Production
// const BaseURL = 'https://api.jogo.ai/api/v1';

//Development
// const BaseURL = 'http://jogo.cpdevserver1.com/jogo/api/v1';

const BaseURL = Config.API_ENDPOINT;
const FeedURL = Config.FEED_API_ENDPOINT;

let headers = {
  'Content-Type': 'application/json',
  Accept: 'application/json',
};

let userId;
let token = null;

//FUNCTION TO LOAD TOKEN AND USER ID

const setConfig = (data = {}) => {
  if (data !== {}) {
    token = data?.user?.access_Token;
    userId = data?.user?.id;

    // setToken(data.access_token);
  }
  // console.log("settt")
  headers = {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    Authorization: `Bearer ${token}`,
  };
};

export {BaseURL, FeedURL, headers, setConfig, userId};
