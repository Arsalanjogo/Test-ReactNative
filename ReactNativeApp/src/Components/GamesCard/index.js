import React from 'react';
import {View, Text, Image} from 'react-native';
import {RippleEffect} from '..';
import {Images, Navigator} from '../../Utils';
import styles from './styles';

export default function GamesCard({
  onPress = () => Navigator.push('GameDetail'),
}) {
  return (
    <RippleEffect style={styles.container} onPress={onPress}>
      <Image style={styles.image} source={Images.GamesDummy} />
      <Text style={styles.title}>Juggling Master</Text>
    </RippleEffect>
  );
}
