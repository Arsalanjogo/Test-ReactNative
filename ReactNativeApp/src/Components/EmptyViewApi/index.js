// @flow
import React from 'react';
import {Image, View, Text, StyleSheet} from 'react-native';
import PropTypes from 'prop-types';

import {Colors, Images, Metrics, Fonts} from '../../Theme';

export default class ErrorViewApi extends React.PureComponent {
  static propTypes = {
    title: PropTypes.string.isRequired,
    image: PropTypes.number,
    containerStyle: PropTypes.oneOfType([
      PropTypes.object,
      PropTypes.array,
      PropTypes.number,
    ]),
  };

  static defaultProps = {
    image: Images.images.emptyViewImage,
    containerStyle: {},
  };

  render() {
    const {containerStyle, title, description, titleStyle, descStyle, image} =
      this.props;
    return (
      <View style={[styles.container, containerStyle]}>
        <Image source={image} resizeMode="contain" />
        <Text style={[styles.textStyle, titleStyle]}>{title}</Text>
        <Text style={[styles.descStyle, descStyle]}>{description}</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  textStyle: {
    marginTop: Metrics.ratio(26),
    marginHorizontal: Metrics.ratio(70),
    fontSize: 20,
    color: Colors.darkGreyBlue,
    fontFamily: Fonts.primaryBold,
    textAlign: 'center',
  },
  descStyle: {
    marginTop: Metrics.ratio(9),
    marginHorizontal: Metrics.ratio(45),
    fontSize: 15,
    color: Colors.darkGreyBlue,
    lineHeight: Metrics.ratio(21),
    textAlign: 'center',
  },
});
