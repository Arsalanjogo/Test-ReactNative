import {Text, View, Image} from 'react-native';
import React, {useEffect, useState} from 'react';
import { Icons, Navigator, Images } from '../../Utils';
import styles from './styles'
import {CustomText, CustomIcon,Button} from '../'
import { Metrics } from '../../Theme';

const Requests = () => {
  const [isFriend, setIsFriend] = useState(true);

  return (
    <View style={styles.itemContainer}>
       <View style={styles.leftView}>
       <Image source={Images.avatar} style={styles.image} resizeMode="contain"/>
        <View style={styles.nameView}>
            <CustomText style={styles.name}>Lorem Epsum</CustomText>
            <CustomText style={styles.userName}>@username</CustomText>
        </View>
       </View>
        
        <View style={styles.rightView}>
        <Button title="Confirm" style={styles.button} textStyle={styles.buttonTextStyle} />
        <CustomIcon name={Icons.Close} size={25} color="white"/>
        </View>
    </View>
  );
};

export default Requests;
