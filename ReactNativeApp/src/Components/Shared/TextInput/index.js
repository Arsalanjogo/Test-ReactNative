import React, { Component } from 'react';
import { View, TextInput, Text, TouchableOpacity, Image } from 'react-native';
import PropTypes from 'prop-types';
import styles from './styles';
import { Colors } from '../../../Theme';
import CustomIcon from '../CustomIcon';
import { Icons } from '../../../Utils';

class Input extends Component {
  static propTypes = {
    label: PropTypes.string,
    onChangeText: PropTypes.func,
    onSubmitEditing: PropTypes.func,
    onFocus: PropTypes.func,
    onBlur: PropTypes.func,
    secureTextEntry: PropTypes.bool,
    customStyle: PropTypes.object,
    labelContainerStyle: PropTypes.object,
    labelStyle: PropTypes.object,
    isRow: PropTypes.bool,
    placeholder: PropTypes.string,
    keyboardType: PropTypes.string,
    isLabel: PropTypes.bool,
    multiline: PropTypes.bool,
    inputStyle: PropTypes.object,
    placeholderColorText: PropTypes.string,
    numberOfLines: PropTypes.number,
    maxLength: PropTypes.number,
    errorType: PropTypes.string,
    textValue: PropTypes.string,
    returnKeyType: PropTypes.string,
    editable: PropTypes.bool,
    required: PropTypes.bool,
    error: PropTypes.bool,
  };

  static defaultProps = {
    label: '',
    onChangeText: undefined,
    onSubmitEditing: undefined,
    onFocus: undefined,
    onBlur: undefined,
    secureTextEntry: false,
    labelContainerStyle: {},
    labelStyle: {},
    customStyle: {},
    isRow: false,
    placeholder: '',
    keyboardType: 'default',
    isLabel: true,
    multiline: false,
    inputStyle: {},
    placeholderColorText: Colors.placeholder,
    numberOfLines: 1,
    errorType: undefined,
    textValue: '',
    editable: true,
    required: false,
    error: false,
    autoFocus: false,
    returnKeyType: 'done',
    onRef: () => { },
  };

  constructor(props) {
    super(props);
    this.state = {
      showError: false,
      textValue: props.textValue,
      isFocused: false,
      hidePassword: this.props.secureTextEntry,
    };
  }
  componentWillReceiveProps(nextProps, prevState) {
    this.setState({
      textValue: nextProps.textValue,
      showError: nextProps.showError,
    });
  }

  handleFocus = () => {
    const { onFocus } = this.props;
    this.setState({ isFocused: true });

    if (onFocus) {
      onFocus();
    }
  };

  handleBlur = () => {
    let { required, textValue, onBlur } = this.props;
    this.setState({ isFocused: false });
    if (required && !textValue) {
      this.setState({ showError: true });
    } else {
      this.setState({ showError: false });
    }

    if (onBlur) {
      onBlur();
    }
  };

  focus = () => {
    this.textInput.focus();
  };

  setText = text => {
    const { onChangeText } = this.props;

    if (onChangeText) {
      onChangeText(text);
    }

    this.textInput.setNativeProps(text);
    this.setState({ textValue: text });
  };
  labelColor() {
    let { textValue, error, labelTextColor } = this.props;
    let { showError } = this.state;
    let labelColor = labelTextColor ? labelTextColor : Colors.light;
    if (showError) labelColor = Colors.error;
    if (textValue && error) labelColor = Colors.error;
    return labelColor;
  }

  borderColor() {
    let { textValue, error, undoBorderColor } = this.props;
    let { showError } = this.state;
    let borderColor = Colors.light;
    if (textValue) borderColor = Colors.primary;
    if (showError) borderColor = Colors.error;
    if (textValue && error) borderColor = Colors.error;
    if (undoBorderColor) return Colors.light;
    else return borderColor;
  }

  keepKeyboardOpen() {
    let { returnKeyType, chat } = this.props;
    return !chat ? returnKeyType !== 'next' : false;
  }

  render() {
    const {
      secureTextEntry,
      customStyle,
      isRow,
      placeholder,
      keyboardType,
      multiline,
      inputStyle,
      placeholderColorText,
      numberOfLines,
      editable,
      label,
      labelStyle,
      labelContainerStyle,
      returnKeyType,
      onSubmitEditing,
      onRef,
      error,
      maxLength,
      isLabel,
      onChange,
      undoBorderColor,
      autoFocus,
      isBorderShow = true,
      errorMessage,
      passwordEye,
      rightIcon,
      rightIconPress,
      ...extraProps
    } = this.props;

    const { textValue, isFocused, showError, hidePassword } = this.state;
    return (
      <View style={[isRow && styles.isRowContainer]}>
        <View style={[styles.inputContainer, customStyle]}>
          {isLabel && (
            <View style={[styles.labelContainer, labelContainerStyle]}>
              <Text
                style={[
                  styles.labelStyle,
                  !isFocused && styles.focusedLabelStyle,
                  { color: error ? Colors.error : this.labelColor() },
                  labelStyle,
                ]}>
                {label}
              </Text>
            </View>
          )}

          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            <TextInput
              autoFocus={autoFocus}
              ref={input => {
                this.textInput = input;
                onRef(input);
              }}
              value={textValue}
              selectionColor={'yellow'}
              maxLength={maxLength}
              underlineColorAndroid="transparent"
              placeholder={!isFocused && !showError ? placeholder : null}
              placeholderTextColor={placeholderColorText || Colors.placeholder}
              autoCapitalize="sentences"
              onChangeText={this.setText}
              onChange={onChange}
              secureTextEntry={hidePassword}
              style={[
                styles.inputStyle(isBorderShow ? this.borderColor() : null),
                inputStyle,
                { borderColor: error ? Colors.error : 'white' },
              ]}
              keyboardType={keyboardType}
              multiline={multiline}
              numberOfLines={numberOfLines}
              textAlignVertical="center"
              onBlur={this.handleBlur}
              onFocus={this.handleFocus}
              editable={editable}
              returnKeyType={returnKeyType}
              onSubmitEditing={onSubmitEditing}
              blurOnSubmit={this.keepKeyboardOpen()}
              {...extraProps}
            />
            {passwordEye ? (
              <TouchableOpacity
                style={{ position: 'absolute', right: 15 }}
                onPress={() =>
                  this.setState({ hidePassword: !this.state.hidePassword })
                }>
                <CustomIcon name={Icons.Eye} size={25} color={Colors.primary} />
              </TouchableOpacity>
            ) : (
              <View></View>
            )}
            {rightIcon ? (
              <TouchableOpacity
                style={{ position: 'absolute', right: 28 }}
                onPress={rightIconPress

                }
              >
                <Image source={rightIcon} />
              </TouchableOpacity>
            ) : (
              <View></View>
            )}
          </View>
          {error && <Text style={styles.errorMsg}>{errorMessage}</Text>}
        </View>

        {isRow ? this.props.children : null}
      </View>
    );
  }
}

export default Input;
