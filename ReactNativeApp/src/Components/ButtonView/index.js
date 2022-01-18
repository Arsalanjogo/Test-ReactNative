// @flow
import React from 'react';
import PropTypes from 'prop-types';
import {TouchableOpacity, Platform} from 'react-native';

let disableClick = false;
export default class ButtonView extends React.PureComponent {
  static propTypes = {
    style: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.object,
      PropTypes.number,
    ]),
    children: PropTypes.node.isRequired,
    isBackgroundBorderLess: PropTypes.bool,
    disableRipple: PropTypes.bool,
    enableClick: PropTypes.bool,
    onPress: PropTypes.func,
    useTouchable: PropTypes.bool,
    debounceTime: PropTypes.number,
    disabled: PropTypes.bool,
    disabledOpacity: PropTypes.number,
  };

  static defaultProps = {
    style: {},
    isBackgroundBorderLess: false,
    disableRipple: false,
    enableClick: false,
    useTouchable: false,
    disabled: false,
    disabledOpacity: 0.5,
    debounceTime: Platform.select({android: 700, ios: 200}),
  };

  _onPress = () => {
    if (this.props.enableClick && this.props.onPress) {
      this.props.onPress();
    } else if (!disableClick) {
      disableClick = true;
      if (this.props.onPress) {
        this.props.onPress();
      }

      setTimeout(() => {
        disableClick = false;
      }, this.props.debounceTime);
    }
  };

  render() {
    const {
      style,
      children,
      isBackgroundBorderLess,
      disableRipple,
      useTouchable,
      disabled,
      disabledOpacity,
      ...rest
    } = this.props;

    const opacity = this.props.disableRipple ? 1 : 0.5;
    const disableStyle = {opacity: disabled ? disabledOpacity : 1};
    return (
      <TouchableOpacity
        style={[style, disableStyle]}
        {...rest}
        onPress={this._onPress}
        disabled={disabled}
        activeOpacity={opacity}>
        {this.props.children}
      </TouchableOpacity>
    );
  }
}
