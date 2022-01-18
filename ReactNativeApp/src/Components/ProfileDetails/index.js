import React, { useState, useCallback, useEffect } from 'react';
import { View, TouchableOpacity , Image} from 'react-native';
import { CustomText, CustomIcon, Button} from '..';
import styles from './styles';
import { Navigator } from '../../Utils';
import moment from 'moment';
import { Icons } from '../../Utils';
import Avatar from '../../../assets/images/avatar.png'

export default function ProfileDetails({details}) {
  return (
    <View style={styles.card}> 

            <Image
              resizeMode="contain"
              source={Avatar}
              style={styles.avatar}
            />
            <View>
            <CustomText style={styles.name}>Lorem Epsum</CustomText>
            <CustomText style={styles.email}>lorem@433.com</CustomText>
            <CustomText style={styles.description}>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin accumsa</CustomText>

            </View>
        
        <TouchableOpacity style={styles.friendsView}>
            <CustomText style={styles.numberOfFriends}>234</CustomText>
            <CustomText style={styles.friendsText}>Friends</CustomText>
        </TouchableOpacity>

    </View>
  );
}



