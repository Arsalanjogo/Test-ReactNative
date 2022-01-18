import React from 'react';
import {View, Text, TextInput} from 'react-native';
import {CustomIcon, CustomText} from '../../index';
import styles from './styles';
import {Colors} from '../../../Theme';
import {Icons, Navigator} from '../../../Utils';

export default function ValidationItem({
  title = 'Validation Message',
  validated,
}) {
  return (
    <View style={styles.container}>
      <CustomIcon
        name={Icons.Checkmark}
        size={25}
        color={validated ? Colors.primary : 'white'}
      />
      <CustomText style={styles.title}>{title}</CustomText>
    </View>
  );
}
