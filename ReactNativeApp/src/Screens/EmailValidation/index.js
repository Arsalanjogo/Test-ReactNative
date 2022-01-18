import {Text, View, Image} from 'react-native';
import React, {useEffect, useState} from 'react';
import {
  RootView,
  Button,
  CustomText,
  Header,
  TextInput,
  Loader,
} from '../../Components';
import styles from './styles';
import {Navigator, Icons, showToast} from '../../Utils';
import SuccessImage from '../../../assets/images/success.png';
import {AuthApi} from '../../Services';
import {connect} from 'react-redux';
// import {login} from '../../Store/Auth/actions';

const EmailValidation = props => {
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [screenLoading, setScreenLoading] = useState(false);

  const {email} = props.route.params;

  onResend = () => {
    setScreenLoading(true);
    AuthApi.resendEmailValidationCode({
      email: email,
    })
      .then(res => res.json())
      .then(response => {
        console.log(response, 'API RES');
        setScreenLoading(false);
        if (response.statusCode === 200) {
          showToast(response.message);
        } else {
          showToast(response.message);
        }
      })
      .catch(err => {
        setScreenLoading(true);
        showToast('Network request failed');
      });
  };

  onConfirm = () => {
    let {login} = props;

    if (code === '') return showToast('Enter OTP');
    else {
      setLoading(true);
      AuthApi.validateEmail({
        // email:email,
        email_verification_token: code,
      })
        .then(res => res.json())
        .then(response => {
          setLoading(false);
          console.log(response, 'API RES');
          if (response.statusCode === 200) {
            // showToast(response.message);
            setLoading(false);
            showToast(response.message);
            login(response.result);
            // Navigator.navigate("Login")
          } else {
            showToast(response.message);
            setLoading(false);
          }
        })
        .catch(err => {
          setLoading(false);
          showToast('Network request failed');
        });
    }
  };

  // console.log(props.route,"PROPS")
  return (
    <RootView>
      <Header
        // showLeftIcon={true}
        showRightIcon={false}
        title={'Email Validation'}
      />

      <Loader visible={screenLoading} />

      <View>
        <View>
          <Image source={SuccessImage} style={styles.successImage} />
          <View style={styles.titleView}>
            <CustomText style={styles.title}>
              We have sent you an email to with the
            </CustomText>
            <CustomText style={styles.title}>
              validation code. Please enter your validation code below
            </CustomText>
          </View>
          <CustomText style={styles.title2}>
            Remember to check your spam folder
          </CustomText>
        </View>

        <View style={styles.inputView}>
          <TextInput
            required
            placeholder={''}
            label={'Validation Code'}
            textValue={code}
            onChangeText={text => {
              setCode(text);
            }}
          />
          <Button
            title={'CONFIRM'}
            style={styles.button}
            onPress={onConfirm}
            loading={loading}
          />
        </View>

        <View style={styles.notReceivedView}>
          <CustomText style={{}}>Not received the email?</CustomText>
          <CustomText style={styles.resendText} onPress={onResend}>
            Resend Code
          </CustomText>
        </View>
      </View>
    </RootView>
  );
};

export default connect(null, null)(EmailValidation);
