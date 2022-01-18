// @flow
import {View, ViewPropTypes, StyleSheet} from 'react-native';
import PropTypes from 'prop-types';
import React from 'react';

import {ImageViewHttp} from '../../Components';
import {Metrics, Colors} from '../../Theme';

const ImageViewHttpBackground = ({
  width,
  height,
  borderRadius,
  containerStyle,
  url,
  children,
  contentStyle,
  isLocal,
}) => {
  return (
    <View
      style={[
        {width, height, borderRadius, overflow: 'hidden'},
        containerStyle,
      ]}>
      <ImageViewHttp
        style={{width, height}}
        placeholderStyle={{width: width / 2, height: height / 2}}
        {...{url, isLocal}}
      />
      <View style={[styles.contentStyle, contentStyle]}>{children}</View>
    </View>
  );
};

ImageViewHttpBackground.propTypes = {
  width: PropTypes.any,
  height: PropTypes.any,
  url: PropTypes.string,
  borderRadius: PropTypes.any,
  containerStyle: ViewPropTypes.style,
  contentStyle: ViewPropTypes.style,
  isLocal: PropTypes.bool,
};

ImageViewHttpBackground.defaultProps = {
  width: Metrics.productImageWidthCarousel,
  height: Metrics.productImageHeightCarousel,
  style: {},
  borderRadius: 12,
  url: '',
  containerStyle: {},
  contentStyle: {},
  isLocal: false,
};

export default React.memo(ImageViewHttpBackground);

const styles = StyleSheet.create({
  contentStyle: {
    position: 'absolute',
    left: 0,
    right: 0,
    top: 0,
    bottom: 0,
    backgroundColor: Colors.blackO1,
    padding: 10,
    justifyContent: 'space-between',
  },
});
