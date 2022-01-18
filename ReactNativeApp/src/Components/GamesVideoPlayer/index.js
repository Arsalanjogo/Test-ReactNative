import React, { useState, useRef, useEffect } from 'react';
import { View, Text, Platform, Modal, TouchableOpacity } from 'react-native';
import Video from 'react-native-video';
import { Colors, Metrics } from '../../Theme';
import { RippleEffect, CustomIcon, CustomText, RootView } from '../index';
import { Icons } from '../../Utils';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import styles from './styles';
import Slider from '@react-native-community/slider';
import * as Animatable from 'react-native-animatable';

export default function GamesVideoPlayer({ source = "", style = {} }) {
  const [mute, setMute] = useState(false);
  const [paused, setPaused] = useState(false);
  const [showControls, setShowControls] = useState(false);
  const [fullScreen, setFullScreen] = useState(false);
  const [isSliding, setSliding] = useState(false);
  const [duration, setDuration] = useState(0);
  const [progress, setProgress] = useState(0);
  const [currentTime, setCurrentTime] = useState(0);
  const [timeLeft, setTimeLeft] = useState('0:00');

  const videoPlayer = useRef(null);
  const controlsView = useRef(null);

  useEffect(() => {
    controlsView.current.fadeIn();
    setTimeout(() => {
      controlsView.current.fadeOut().then(() => setShowControls(false));
    }, 2000);
  }, []);

  const showControlsView = () => {
    controlsView.current.fadeIn();
    setTimeout(() => {
      controlsView.current.fadeOut().then(() => setShowControls(false));
    }, 2000);
  };

  const onLoad = data => {
    let time = data.duration;
    let minutes = Math.floor(time / 60);
    let seconds = parseInt(time - minutes * 60);
    if (seconds.toString().length == 1) seconds = '0' + seconds;
    setDuration(data.duration);
    setTimeLeft(`${minutes}:${seconds}`);
  };

  const onProgress = data => {
    const { currentTime } = data;
    let time = (duration - currentTime).toFixed(2);
    if (time > 0) {
      let minutes = Math.floor(time / 60);
      let seconds = parseInt(time - minutes * 60);
      if (seconds.toString().length == 1) seconds = '0' + seconds;
      let height = currentTime / duration;
      setProgress(height);
      setCurrentTime(currentTime);
      setTimeLeft(`${minutes}:${seconds}`);
    }
  };

  const onSeek = data => {
    setSliding(false);
    setShowControls(false);
    let seek = duration * data;
    videoPlayer.current.seek(seek);
    let time = (duration - seek).toFixed(2);
    let minutes = Math.floor(time / 60);
    let seconds = parseInt(time - minutes * 60);
    if (seconds.toString().length == 1) seconds = '0' + seconds;
    let height = seek / duration;
    setProgress(height);
    setCurrentTime(seek);
    setTimeLeft(`${minutes}:${seconds}`);
  };

  return (
    <TouchableOpacity activeOpacity={1} onPress={showControlsView}>
      <View style={styles.container}>
        {!fullScreen ? (
          <Video
            ref={videoPlayer}
            source={source ? source : require('../../../assets/videos/Juggling.mp4')}
            style={style ? style : styles.video}
            resizeMode="cover"
            repeat={true}
            controls={false}
            muted={mute}
            paused={paused || isSliding}
            fullscreenOrientation="landscape"
            onLoad={onLoad}
            onProgress={onProgress}
            progressUpdateInterval={1000}
          />
        ) : null}
        <View style={styles.controlsView}>
          <Animatable.View style={styles.iconsView} ref={controlsView}>
            <RippleEffect
              onPress={() => {
                setFullScreen(true);
                videoPlayer.current.seek(currentTime);
                // videoPlayer.current.presentFullscreenPlayer();
              }}
              style={styles.controlIcons}>
              <Icon
                name="fullscreen"
                size={Metrics.largeFont}
                color={Colors.textLight}
              />
            </RippleEffect>
            <RippleEffect
              onPress={() => setMute(!mute)}
              style={styles.controlIcons}>
              <CustomIcon
                name={mute ? Icons.SoundOff : Icons.SoundOn}
                size={Metrics.largeFont}
                color={Colors.textLight}
              />
            </RippleEffect>
          </Animatable.View>
          <View style={styles.bottomControls}>
            <CustomIcon
              name={paused ? Icons.VideoPlay : Icons.Pause}
              size={Metrics.largeFont}
              color={Colors.textLight}
              style={{ width: Metrics.width * 0.05 }}
              onPress={() => setPaused(!paused)}
            />
            <Slider
              style={styles.slider}
              value={progress}
              minimumValue={0}
              maximumValue={1}
              minimumTrackTintColor={Colors.textLight}
              maximumTrackTintColor={Colors.darkGray}
              thumbTintColor={isSliding ? Colors.primary : 'transparent'}
              onSlidingComplete={onSeek}
              onSlidingStart={() => {
                setSliding(true);
                showControlsView();
              }}
            />
            <CustomText style={{ width: Metrics.width * 0.1 }}>
              {timeLeft}
            </CustomText>
          </View>
        </View>

        {fullScreen ? (
          <Modal
            onRequestClose={() => {
              videoPlayer.current.seek(currentTime);
              setFullScreen(false);
            }}
            animationType="fade"
            visible={fullScreen}
            transparent={true}>
            <View style={styles.fullScreenView}>
              <View style={styles.fullScreenIconsView}>
                <RippleEffect
                  onPress={() => {
                    setFullScreen(!fullScreen);
                    videoPlayer.current.seek(currentTime);
                  }}
                  style={[styles.controlIcons]}>
                  <Icon
                    name="fullscreen-exit"
                    size={Metrics.largeFont}
                    color={Colors.textLight}
                  />
                </RippleEffect>
                <RippleEffect
                  onPress={() => setMute(!mute)}
                  style={[styles.controlIcons]}>
                  <CustomIcon
                    name={mute ? Icons.SoundOff : Icons.SoundOn}
                    size={Metrics.largeFont}
                    color={Colors.textLight}
                  />
                </RippleEffect>
              </View>

              <View style={styles.fullScreenBottomControls}>
                <CustomIcon
                  name={paused ? Icons.VideoPlay : Icons.Pause}
                  size={Metrics.largeFont}
                  color={Colors.textLight}
                  style={{ width: Metrics.width * 0.05 }}
                  onPress={() => setPaused(!paused)}
                />
                <Slider
                  style={styles.fullScreenSlider}
                  value={progress}
                  minimumValue={0}
                  maximumValue={1}
                  minimumTrackTintColor={Colors.textLight}
                  maximumTrackTintColor={Colors.darkGray}
                  thumbTintColor={isSliding ? Colors.primary : 'transparent'}
                  onSlidingComplete={onSeek}
                  onSlidingStart={() => {
                    setSliding(true);
                    showControlsView();
                  }}
                />
                <CustomText style={{ width: Metrics.width * 0.1 }}>
                  {timeLeft}
                </CustomText>
              </View>

              <Video
                ref={videoPlayer}
                source={require('../../../assets/videos/Juggling.mp4')}
                style={styles.fullScreenVideo}
                resizeMode="contain"
                repeat={true}
                controls={false}
                muted={mute}
                paused={paused || isSliding}
                fullscreen={false}
                onLoad={onLoad}
                onProgress={onProgress}
              />
            </View>
          </Modal>
        ) : null}
      </View>
    </TouchableOpacity>
  );
}
