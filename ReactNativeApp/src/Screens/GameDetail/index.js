import React, {useRef, useState} from 'react';
import {View, Text, Image, ScrollView} from 'react-native';
import {
  Button,
  CustomIcon,
  CustomText,
  Header,
  RippleEffect,
  RootView,
} from '../../Components';
import {Icons, Images, Navigator} from '../../Utils';
import styles from './styles';
import Video from 'react-native-video';
import {Colors, Metrics} from '../../Theme';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import GamesVideoPlayer from '../../Components/GamesVideoPlayer';

export default function GameDetail() {
  const [mute, setMute] = useState(false);
  const [fullScreen, setFullScreen] = useState(true);
  const videoPlayer = useRef(null);

  return (
    <RootView top={0}>
      <Header absolute />
      <Image source={Images.GameBG} style={styles.image} />
      <ScrollView
        style={styles.container}
        contentContainerStyle={{paddingHorizontal: Metrics.defaultMargin}}>
        <CustomText bold style={styles.title}>
          Juggling Master
        </CustomText>
        <View style={styles.videoContainer}>
          <GamesVideoPlayer />
        </View>
        <CustomText style={styles.description}>
          Are you a juggling master? You have 45 seconds to keep the ball up by
          using your feet, make sure the ball doesn't touch the ground! The
          longer you juggle, the more points you win.
        </CustomText>

        <CustomText bold style={styles.heading}>
          Your High Score
        </CustomText>
        <CustomText style={styles.score}>120 Juggles</CustomText>
      </ScrollView>
      <Button
        title="Play"
        background
        onPress={() => Navigator.push('GameResult')}
      />
    </RootView>
  );
}
