import {Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {RootView,ProfileDetails,Header,Button,CustomIcon,FriendsOptionsModal} from '../../Components';
import { Icons } from '../../Utils';
import styles from './styles'
import { Navigator } from '../../Utils';

const OthersProfile = () => {
  const [isFriend, setIsFriend] = useState(true);
  const [isRequested, setIsRequested] = useState(true);
  const [moreModalVisible, setMoreModalVisible] = useState(false)

  onCancel = () => {
    setMoreModalVisible(false)
  }

  onBlock = () => {
    console.log("Block")
  }

  onUnfriend = () => {
    console.log("Unfriend")
  }

  onShare = () => {
    console.log("Share")
  }

  return (
    <RootView>
      <Header showRightIcon={true} rightIcon={Icons.Share2} title={'Username'} />
     <ProfileDetails/>
    {isFriend ?
    <View style={styles.toRow}>
     <Button secondary style={styles.sendButton} title="SEND MESSAGE" />
    <CustomIcon name={Icons.More} style={styles.moreIcon} onPress={()=> setMoreModalVisible(true)}/>
    </View> :
    isRequested ?
      <Button secondary withIcon IconName={Icons.Checkmark} iconStyle={styles.buttonIcon} style={styles.button} title="REQUESTED" onPress={()=> setIsRequested(false)}/>
      : <Button onPress={()=> setIsRequested(true)} style={styles.button} title="ADD FRIEND"/>
    }

  <FriendsOptionsModal visible={moreModalVisible} onCancel={onCancel} onBlock={onBlock} onShare={onShare} onUnfriend={onUnfriend}/>
    </RootView>
  );
};

export default OthersProfile;
