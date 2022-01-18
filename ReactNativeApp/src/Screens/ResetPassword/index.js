import {Text, View, Image} from 'react-native';
import React, {useEffect, useState} from 'react';
import {
  RootView,
  Button,
  CustomText,
  Header,
  TextInput,
  Loader
} from '../../Components';
import styles from './styles';
import {Navigator, Icons} from '../../Utils';
import SuccessImage from '../../../assets/images/success.png';
import { AuthApi } from '../../Services';
import { connect } from 'react-redux';
import { validateEmail } from '../../Utils/Helpers';

const ResetPassword = () => {
  const [value, setValue] = useState('');
  const [email, setEmail] = useState('');
  const [emailSent, setEmailSent] = useState(false);

  const [loading, setLoading] = useState(false);

  resetPassword = () => {
    if (email == '') return showToast('Please enter your email');
    if(!validateEmail(email)) return showToast('Please enter valid email')
    setLoading(true)

    AuthApi.requestPassword({
      email:email
    })
      .then(res => res.json())
      .then(response => {
          setLoading(false)
        console.log(response,"API RES")
        if (response.statusCode === 200) {
          // showToast(response.message);
          setLoading(false)
          Navigator.navigate('OTPCode',{email});
        } else {
          showToast(response.message);
          setLoading(false)
        }
      })
      .catch(err => {
        setLoading(false)
        showToast('Network request failed');
      });
  }


  return (
    <RootView>
      <Header
        showRightIcon={emailSent ? true : false}
        showLeftIcon={emailSent ? false : true}
        title={emailSent ? 'Reset Link Sent' : 'Reset Password'}
        rightIcon={emailSent ? Icons.Close : false}
        onPressRight={() => Navigator.navigate('Login')}
      />
   
        <View>
          <View style={styles.titleView}>
            <CustomText style={styles.title}>
              Please write your account email address to get a password reset code
            </CustomText>
          </View>

          <TextInput
            required
            placeholder={'lorem.ipsum@abcd.com'}
            label={'EMAIL ADDRESS'}
            returnKeyType="next"
            textValue={email}
            onChangeText={text => {
              setEmail(text);
            }}
          />

          <Button
            title={'SEND RESET CODE'}
            style={styles.button}
            onPress={this.resetPassword}
            loading={loading}

          />
        </View>
      
    </RootView>
  );
};

export default connect(null,{})(ResetPassword);
