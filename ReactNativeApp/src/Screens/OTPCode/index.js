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
import {Navigator, Icons, showToast} from '../../Utils';
import SuccessImage from '../../../assets/images/success.png';
import { AuthApi } from '../../Services';
import { connect } from 'react-redux';

const OTPCode = (props) => {
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);
  const {email} = props.route.params;

  onConfirm = () => {
    if(code==='') {
      showToast("Enter OTP")
    }
    else {
      Navigator.navigate("CreateNewPassword",{code})
    }
  }

  // console.log(props.route,"PROPS")
  return (
    <RootView>
      <Header
        // showLeftIcon={true}
        showRightIcon={false}
        title={'Reset Code'}
      />

        <View>
         <View>
        <Image source={SuccessImage} style={styles.successImage} />
        <View style={styles.titleView}>
          <CustomText style={styles.title}>
            Your password reset code was sent to
          </CustomText>
          <CustomText style={styles.title}>{email}</CustomText>
        </View>
        <CustomText style={styles.title2}>
          Remember to check your spam folder
        </CustomText>
       
      </View>

          <View style={styles.inputView}>
          <TextInput
            required
            placeholder={''}
            label={'Password Reset Code'}
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
        </View>
      
    </RootView>
  );
};

export default connect(null,{})(OTPCode);
