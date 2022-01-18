import {Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {RootView,ProfileDetails,Header,Button} from '../../Components';
import { Icons } from '../../Utils';
import styles from './styles'
import { Navigator } from '../../Utils';

const MyProfile = () => {
  const [value, setValue] = useState('');

  return (
    <RootView>
      <Header showRightIcon={true} rightIcon={Icons.SoundOff} title={'Username'} onPressRight={()=> Navigator.navigate('NotificationsCenter')}/>
     <ProfileDetails/>
     <Button style={styles.button} title="EDIT PROFILE" onPress={()=> Navigator.navigate('EditProfile')}/>

    </RootView>
  );
};

export default MyProfile;
