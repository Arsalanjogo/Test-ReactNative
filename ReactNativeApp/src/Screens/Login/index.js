import React, {useEffect, useState} from 'react';
import {View, Keyboard} from 'react-native';
import {useDispatch} from 'react-redux';
import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';

import {
  RootView,
  Button,
  CustomText,
  Header,
  TextInput,
  Loader,
} from '../../Components';
import {Navigator, Util, showToast} from '../../Utils';
import {validateEmail} from '../../Utils/Helpers';
import {AUTH_IDENTIFIER_LOGIN} from '../../ducks/ActionTypes';
import {API_USER_LOGIN} from '../../Config/WebService';
import {authActions} from '../../ducks/auth';

import styles from './styles';

let inputs = {};

const Login = () => {
  const dispatch = useDispatch();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  // const [keyboardHeight, setKeyboardHeight] = useState(0);

  // const onKeyboardDidShow = e => setKeyboardHeight(e.endCoordinates.height);
  // const onKeyboardDidHide = () => setKeyboardHeight(0);

  // useEffect(() => {
  //   Keyboard.addListener('keyboardDidShow', e => onKeyboardDidShow(e));
  //   Keyboard.addListener('keyboardDidHide', e => onKeyboardDidHide(e));
  //   return () => {
  //     Keyboard.removeAllListeners('keyboardDidShow', e => onKeyboardDidShow(e));
  //     Keyboard.removeAllListeners('keyboardDidHide', e => onKeyboardDidHide(e));
  //   };
  // }, []);

  const onChange = (name, val) => {
    if (name === 'email') {
      setEmail(val);
    } else setPassword(val);
  };

  const focusNextField = id => inputs[id].focus();

  const onPressLogin = () => {
    // if (email == '') return showToast('Please enter your email');
    // if (!validateEmail(email)) return showToast('Please enter valid email');
    // if (password == '') return showToast('Please enter your password');

    Keyboard.dismiss();
    const payload = {
      email: email,
      password: password,
    };

    dispatch(
      authActions.requestUser(
        payload,
        AUTH_IDENTIFIER_LOGIN,
        API_USER_LOGIN,
        () => {
          Navigator.replace('Home');
        },
      ),
    );
  };

  return (
    <RootView>
      <Header
        onPressLeft={() => Navigator.navigate('LoginOptions')}
        showRightIcon={false}
        title={'Login using Email'}
      />
      <KeyboardAwareScrollView
        showsVerticalScrollIndicator={false}
        enableOnAndroid={true}
        keyboardShouldPersistTaps="handled"
        bounces={false}
        // contentContainerStyle={{
        //   paddingBottom: -keyboardHeight - 50,
        // }}
        extraScrollHeight={Platform.OS == 'android' && 50}
        style={{flex: 1}}>
        <View style={styles.inputView}>
          <TextInput
            required
            placeholder={'Please write your email'}
            label={'EMAIL'}
            returnKeyType="next"
            textValue={email}
            onRef={ref => (inputs['email'] = ref)}
            onChangeText={text => onChange('email', text)}
            onSubmitEditing={() => focusNextField('password')}
          />
          <TextInput
            passwordEye
            required
            placeholder={'Please write your password'}
            label={'PASSWORD'}
            returnKeyType="next"
            textValue={password}
            secureTextEntry={true}
            onRef={ref => (inputs['password'] = ref)}
            onChangeText={text => onChange('password', text)}
          />
        </View>
        <Button
          title={'login'}
          style={styles.button}
          onPress={onPressLogin}
          // loading={this.state.loading}
        />
        <View style={styles.titleView}>
          <CustomText style={styles.title1}>Forgot your password? </CustomText>
          <CustomText
            style={styles.title2}
            onPress={() => Navigator.navigate('ResetPassword')}>
            {' '}
            Reset Password
          </CustomText>
        </View>
      </KeyboardAwareScrollView>
      <Loader type={Util.getTypeAuth(AUTH_IDENTIFIER_LOGIN)} />
    </RootView>
  );
};

export default Login;
