import {
  Text,
  View,
  Image,
  TouchableOpacity,
  ScrollView,
  Platform,
} from 'react-native';
import React, {useEffect, useState} from 'react';
import styles from './styles';
import {RootView, CustomText, Button, Loader} from '../../Components';
import Logo from '../../../assets/logo/logoTransparent.png';
import GmailIcon from '../../../assets/images/gmail.png';
import FacebookIcon from '../../../assets/images/facebook.png';
import AppleIcon from '../../../assets/images/apple.png';
import {Navigator, showToast} from '../../Utils';
import GmailLogin from '../../Utils/GmailLogin';
import {AuthApi} from '../../Services';
// import {login} from '../../Store/Auth/actions';
import {connect} from 'react-redux';
import {LoginManager, Profile} from 'react-native-fbsdk-next';

const LoginOptions = props => {
  const [value, setValue] = useState('');
  const [loading, setLoading] = useState(false);

  loginWithFacebook = () => {
    LoginManager.logInWithPermissions(['public_profile', 'email']).then(
      result => {
        console.log(result, 'FB');
        if (result.isCancelled) {
          console.log('Login cancelled');
          showToast('Login cancelled');
        } else {
          const currentProfile = Profile.getCurrentProfile().then(function (
            currentProfile,
          ) {
            console.log(currentProfile, 'PROFILE');
            Navigator.navigate('PickUsername', {facebookInfo: currentProfile});

            if (currentProfile) {
              console.log(
                'The current logged user is: ' +
                  currentProfile.name +
                  '. His profile id is: ' +
                  currentProfile.userID,
              );
            }
          });
          console.log(
            'Login success with permissions: ' +
              result.grantedPermissions.toString(),
          );
          setLoading(false);
          showToast('Success');
          // Navigator.navigate("PickUsername",{facebookInfo:userInfo})
        }
      },
      function (error) {
        console.log('Login fail with error: ' + error);
      },
    );
  };

  loginWithGmail = () => {
    GmailLogin.signInGoogle(userInfo => {
      setLoading(true);
      if (userInfo) {
        console.log(userInfo);
        AuthApi.socialLogin({
          email: userInfo.email,
          provider_id: userInfo.id,
        })
          .then(res => res.json())
          .then(response => {
            console.log(response, 'API RES');
            if (response.statusCode === 200) {
              props.login(response.result);
              setLoading(false);
            } else if (response.statusCode === 500) {
              Navigator.navigate('PickUsername', {gmailInfo: userInfo});
              setLoading(false);
            } else {
              showToast(response.message);
              setLoading(false);
            }
          })
          .catch(err => {
            showToast('Network request failed');
            setLoading(false);
          });
      } else {
        showToast('Something went wrong');
        setLoading(false);
      }
    });
  };

  function SocialLoginButton(icon, title, onPress) {
    return (
      <TouchableOpacity
        onPress={onPress}
        style={[
          styles.socialButton,
          {backgroundColor: title === 'Facebook' ? '#1877F2' : 'white'},
        ]}>
        <View style={styles.firstView}>
          <Image resizeMode="contain" source={icon} style={styles.socialIcon} />
        </View>
        <View style={styles.secondView}>
          <CustomText style={{color: title === 'Facebook' ? 'white' : 'black'}}>
            Continue with {title}
          </CustomText>
        </View>
      </TouchableOpacity>
    );
  }

  return (
    <RootView>
      <ScrollView>
        <Image resizeMode="contain" source={Logo} style={styles.logo} />
        <Loader visible={loading} />

        <View style={styles.titleView}>
          <CustomText style={styles.screenTitle}>Welcome,</CustomText>
          <CustomText style={styles.screenTitle}>
            Time to experience the best football app
          </CustomText>
        </View>

        {SocialLoginButton(FacebookIcon, 'Facebook', loginWithFacebook)}
        {SocialLoginButton(GmailIcon, 'Google', loginWithGmail)}
        {SocialLoginButton(AppleIcon, 'Apple', () => console.log('Apple'))}

        <View style={styles.titleView}>
          <CustomText style={styles.screenTitle}>or</CustomText>
        </View>

        <Button
          onPress={() => Navigator.navigate('PickUsername')}
          title="CREATE AN ACCOUNT"
          style={styles.createButton}
        />
        <View style={styles.loginTitleView}>
          <CustomText style={styles.alreadyText}>
            Already have an account?
          </CustomText>
          <CustomText
            style={styles.loginText}
            onPress={() => Navigator.navigate('Login')}>
            Login
          </CustomText>
        </View>
      </ScrollView>
    </RootView>
  );
};

export default connect(null, null)(LoginOptions);
