import {Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {RootView,Header, CustomText, Requests} from '../../Components';
import { Icons } from '../../Utils';
import styles from './styles'
import { Navigator } from '../../Utils';
import {Colors, Metrics} from '../../Theme'
import { TouchableOpacity } from 'react-native-gesture-handler';

const NotificationsCenter = () => {
  const [value, setValue] = useState('');
  const [tabValue, setTabValue] = useState(0);


  return (
    <RootView>
      <Header title={'Notification Center'} />
      <View style={styles.tabBar}>
        <TouchableOpacity onPress={()=> setTabValue(0)}  style={[styles.tabItem,{borderBottomWidth: tabValue === 0 ? 2 : 0.5, borderColor: tabValue === 0 ? Colors.primary : Colors.darkGray}]}>
        <CustomText style={styles.tabHeading}>Activity</CustomText>
        </TouchableOpacity>

        <TouchableOpacity onPress={()=> setTabValue(1)} style={[styles.tabItem,{borderBottomWidth: tabValue === 1 ? 2 : 0.5, borderColor: tabValue === 1 ? Colors.primary : Colors.darkGray}]}>
        <CustomText  style={styles.tabHeading}>Requests - 1</CustomText>
        </TouchableOpacity>
      </View>

      <Requests />
    </RootView>
  );
};

export default NotificationsCenter;
