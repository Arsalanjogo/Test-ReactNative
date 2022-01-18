import PropTypes from 'prop-types';
import React from 'react';
import {Dimensions} from 'react-native';

import {ImageViewHttpBackground} from '../../Components';
import styles from './styles';

const ParallaxImage = ({url}) => {
  const {width, height} = Dimensions.get('window');

  return (
    <ImageViewHttpBackground
      // url={url}
      url={url.thumbnail || url.url}
      width={width}
      height={height * 0.42}
      containerStyle={styles.imageStyle}
    />
  );
};

ParallaxImage.propTypes = {
  url: PropTypes.any.isRequired,
};
ParallaxImage.defaultProps = {};

export default React.memo(ParallaxImage, (prevProps, nextProps) => {
  return prevProps.url === nextProps.url;
});

//export default ParallaxImage;
