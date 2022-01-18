import { Text, View, Keyboard, Image } from 'react-native';
import React, { Component } from 'react';

import {
  RootView,
  Button,
  CustomText,
  Header,
  ValidationItem,
  TextInput,
} from '../../Components';
import styles from './styles';
import { Navigator, Icons } from '../../Utils';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import SuccessImage from '../../../assets/images/success.png';
import { AuthApi } from '../../Services';
import { hasLowerCase, hasUpperCase, hasNumber, hasSpecialCharachter } from '../../Utils/Helpers'


class CreateNewPassword extends Component {
  constructor(props) {
    super(props);
    this.state = {
      code: this.props.route.params.code,
      password: '',
      keyboardHeight: 0,
      passwordChanged: false,
      loading: false,
      hasLowerCase: false,
      hasUpperCase: false,
      hasNumber: false,
      hasSpecialCharachter: false,
    };
    this.inputs = {};
  }

  validatePassword = (str) => {
    this.setState({
      hasLowerCase: hasLowerCase(str),
      hasUpperCase: hasUpperCase(str),
      hasSpecialCharachter: hasSpecialCharachter(str),
      hasNumber: hasNumber(str)
    })
  }

  resetPassword = () => {
    let { code, password, hasLowerCase, hasNumber, hasSpecialCharachter, hasUpperCase } = this.state;
    if (password == '') return showToast('Please enter your password');
    if (hasLowerCase &&
      hasUpperCase &&
      hasNumber &&
      hasSpecialCharachter) {
      this.setState({ loading: true });
      AuthApi.resetPassword({
        password_reset_token: code,
        password: password,
      })
        .then(res => res.json())
        .then(response => {
          this.setState({ loading: false });
          // console.log('TRAINER LOGIN => ', response);
          // console.log(response,"API RES")
          if (response.statusCode === 200) {
            // showToast(response.message);
            this.setState({ loading: false, passwordChanged: true });

          } else {
            showToast(response.message);
            this.setState({ loading: false, passwordChanged: false });

          }
        })
        .catch(err => {
          this.setState({ loading: false, passwordChanged: false });
          showToast('Network request failed');
        });
    }

  }

  onChange(name, val) {
    this.setState({ [name]: val });
  }

  focusNextField(id) {
    this.inputs[id].focus();
  }

  onKeyboardDidShow(e) {
    this.setState({ keyboardHeight: e.endCoordinates.height });
  }

  onKeyboardDidHide() {
    this.setState({ keyboardHeight: 0 });
  }

  componentDidMount() {
    Keyboard.addListener('keyboardDidShow', e => this.onKeyboardDidShow(e));
    Keyboard.addListener('keyboardDidHide', e => this.onKeyboardDidHide(e));
  }

  // componentWillUnmount() {
  //   Keyboard.removeListener('keyboardDidShow', e => this.onKeyboardDidShow(e));
  //   Keyboard.removeListener('keyboardDidHide', e => this.onKeyboardDidHide(e));
  // }

  renderSuccess = () => {
    return (
      <View>
        <Image source={SuccessImage} style={styles.successImage} />
        <View style={styles.titleView}>
          <CustomText style={styles.title}>
            You successfully changed your password. Please login using your new
            password
          </CustomText>
        </View>

        <Button
          title={'LOGIN'}
          style={styles.button}
          onPress={() => Navigator.navigate('Login')}
        />
      </View>
    );
  };

  render() {
    const { hasLowerCase, hasNumber, hasSpecialCharachter, hasUpperCase } = this.state;

    return (
      <RootView>
        <Header
          showRightIcon={this.state.passwordChanged ? true : false}
          showLeftIcon={this.state.passwordChanged ? false : true}
          title={
            this.state.passwordChanged
              ? 'Password Saved'
              : 'Create New Password'
          }
          rightIcon={this.state.passwordChanged ? Icons.Close : false}
          onPressRight={() => Navigator.navigate('Login')}
        />
        {this.state.passwordChanged ? (
          this.renderSuccess()
        ) : (
          <KeyboardAwareScrollView
            showsVerticalScrollIndicator={false}
            enableOnAndroid={true}
            keyboardShouldPersistTaps="handled"
            bounces={false}
            contentContainerStyle={{
              paddingBottom: -this.state.keyboardHeight - 50,
            }}
            extraScrollHeight={Platform.OS == 'android' && 50}
            style={{ flex: 1 }}>
            <View style={styles.titleView}>
              <CustomText style={styles.title}>
                Please create a new password
              </CustomText>
            </View>
            <View style={styles.inputView}>


              <TextInput
              passwordEye
                required
                placeholder={'Please write your pasword'}
                label={'NEW PASSWORD*'}
                textValue={this.state.password}
                secureTextEntry={true}
                onRef={ref => {
                  this.inputs['password'] = ref;
                }}
                onChangeText={text => {
                  this.onChange('password', text);
                  this.validatePassword(text)
                }}
              />
            </View>

            <View style={styles.validationView}>
              <CustomText style={styles.validationTitle}>
                Complete these password requirements:
              </CustomText>

              <ValidationItem validated={hasLowerCase ? true : false} title="One lowercase character" />
              <ValidationItem validated={hasUpperCase ? true : false} title="One uppercase character" />
              <ValidationItem validated={hasNumber ? true : false} title="One number" />
              <ValidationItem validated={hasSpecialCharachter ? true : false} title="One special" />
              <ValidationItem validated={this.state.password.length >= 8 ? true : false} title="Min. eight character" />
            </View>

            <Button
              title={'SAVE NEW PASSWORD'}
              style={styles.button}
              onPress={this.resetPassword}
              loading={this.state.loading}
            />
          </KeyboardAwareScrollView>
        )}
      </RootView>
    );
  }
}

export default CreateNewPassword;
