// @flow
import React from 'react';
import {Platform} from 'react-native';
import {useSelector} from 'react-redux';
import PropTypes from 'prop-types';
import ImageLoad from 'react-native-image-placeholder';

import Image from '../Image';
import {networkSelectors} from '../../ducks/network';

const ImageViewHttp = ({isShowActivity, cache, url, isLocal, ...rest}) => {
  const networkInfo = useSelector(networkSelectors.getNetworkInfo);

  if (isLocal) {
    return <Image {...rest} source={url} />;
  }

  return url ? (
    <ImageLoad
      isShowActivity={false}
      source={{uri: url, cache}}
      networkInfo={networkInfo}
      {...rest}
    />
  ) : (
    <ImageLoad
      {...rest}
      isShowActivity={false}
      source={{uri: Platform.select({android: 'dummy', ios: ''})}}
    />
  );
};

ImageViewHttp.propTypes = {
  // placeholderSource
  style: PropTypes.oneOfType([PropTypes.object, PropTypes.number]),
  isShowActivity: PropTypes.bool,
  url: PropTypes.any,
  isLocal: PropTypes.bool,
  cache: PropTypes.string,
};

ImageViewHttp.defaultProps = {
  isShowActivity: false,
  url: '',
  style: {},
  isLocal: false,
  cache: 'default',
};

export default ImageViewHttp;
