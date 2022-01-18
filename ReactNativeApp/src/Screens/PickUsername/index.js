import { Text, View } from 'react-native';
import React, { useEffect, useState } from 'react';
import {
  RootView,
  Button,
  CustomText,
  Header,
  TextInput,
  Loader
} from '../../Components';
import styles from './styles';
import { Navigator } from '../../Utils';
import { showToast } from '../../Utils'
import { AuthApi } from '../../Services';

const PickUsername = (props) => {
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState('');
  const [fname, setFname] = useState('');
  const [lname, setLname] = useState('');
  const [photo, setPhoto] = useState('')
  const [isSocialLogin, setIsSocialLogin] = useState(false);
  const [username, setUsername] = useState('');
  const [providerId, setProviderId] = useState('')
  // console.log(props.route.params?.gmailInfo,"{PPRr")

  

  const onVerifyUsername = () => {
    setLoading(true)
    if (username == '') return showToast('Please enter your name');
    AuthApi.verifyUsername({
      username: username
    })
      .then(res => res.json())
      .then(response => {
        setLoading(false)
        // console.log(response,"API RES")
        if (response.statusCode === 200) {
          // showToast(response.message);
          setLoading(false)
          Navigator.navigate('Register',{userName:username,isSocialLogin,fname,lname,email,providerId});
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

  useEffect(() => {
    console.log("PROPSSSSSS,",props)
    if (props.route.params) {
      const {email, familyName, givenName, photo,id} = props.route.params.gmailInfo;
      setEmail(email);
      setLname(familyName);
      setFname(givenName);
      setIsSocialLogin(true)
      setProviderId(id)
      // setPhoto(photo)
    }
    // else {
    //   setLogin(false);
    // }
  }, [props]);

  return (
    <RootView>
      <Header showRightIcon={false} title={'Pick Username'} />

      <View style={styles.titleView}>
        <CustomText style={styles.title}>
          Pick a username for your new account.
        </CustomText>
        <CustomText style={styles.title}>
          You can always change it later.
        </CustomText>
      </View>

      <TextInput
      maxLength={20}
        required
        placeholder={'username'}
        label={'SELECT USERNAME'}
        returnKeyType="next"
        textValue={username}
        onChangeText={text => {
          setUsername(text.replace(/[^a-zA-Z0-9._]+/g, ''));
        }}
      />

      <Button
        title={'CONTINUE'}
        style={styles.button}
        onPress={onVerifyUsername}
        loading={loading}

      />


    </RootView>
  );
};

export default PickUsername;
