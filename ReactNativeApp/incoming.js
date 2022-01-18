import React, {useState, useRef, useEffect} from 'react';
import {
  View,
  Text,
  Platform,
  Modal,
  TouchableOpacity,
  ActivityIndicator,
  Image,
} from 'react-native';
import Video from 'react-native-video';
import InViewPort from 'react-native-inviewport';
import {Colors, Metrics} from '../../Theme';
import {RippleEffect, CustomIcon, CustomText, Loader} from '../index';
import {Icons, Images} from '../../Utils';
import styles from './styles';
import Slider from '@react-native-community/slider';
import {connect} from 'react-redux';
import {controlVolume} from '../../Store/FeedPost/actions';

const FeedVideoPlayer = React.memo(
  ({
    source = '',
    style = {},
    mute,
    videoVolumme,
    timeLeft,
    setTimeLeft,
    controlFeedVolume,
    isVisible = false,
    index,
    currentIndex,
  }) => {
    const [paused, setPaused] = useState();
    const [fullScreen, setFullScreen] = useState(false);
    const [isSliding, setSliding] = useState(false);
    const [duration, setDuration] = useState(0);
    const [progress, setProgress] = useState(0);
    const [currentTime, setCurrentTime] = useState('00:00');
    const [isVideoLoaded, setIsVideoLoaded] = useState(false);

    let videoPlayer = () => Video;

    useEffect(() => {
      setPaused(!isVisible);
      // videoPlayer.seek(0);
    }, [isVisible]);

    //npm
    const onLoad = data => {
      let time = data.duration;
      let minutes = Math.floor(time / 60);
      let seconds = parseInt(time - minutes * 60);
      if (seconds.toString().length == 1) seconds = '0' + seconds;
      setDuration(data.duration);
      setTimeLeft(`${minutes}:${seconds}`);
    };

    const onProgress = data => {
      const {currentTime} = data;
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
      videoPlayer.seek(seek);
      let time = (duration - seek).toFixed(2);
      let minutes = Math.floor(time / 60);
      let seconds = parseInt(time - minutes * 60);
      if (seconds.toString().length == 1) seconds = '0' + seconds;
      let height = seek / duration;
      setProgress(height);
      setCurrentTime(seek);
      setTimeLeft(`${minutes}:${seconds}`);
    };

    const [opacity, setOpacity] = useState(0);

    const _onBuffer = data => {
      console.log(data, 'isbuffering');
      const {isBuffering} = data;
      // this.setState({
      //   isBuffering: isBuffering,
      // });
      setOpacity(isBuffering ? 1 : 0);
    };

    const onLoadVideo = () => setIsVideoLoaded(true);

    const pauseVideo = () => {
      if (videoPlayer) {
        videoPlayer.pauseAsync();
      }
    };

    const playVideo = () => {
      if (videoPlayer) {
        videoPlayer.playAsync();
      }
    };

    const handlePlaying = isVisible =>
      index === currentIndex ? playVideo() : pauseVideo();

    // const renderLoader = () => {
    //   const {isFocused} = this.props;
    //   const {isBuffering, isPause, isVideoLoaded} = this.state;

    //   const videoPaused = isPause || !isFocused;

    //   const loading = isBuffering || !isVideoLoaded;

    //   return loading ? (
    //     <Image source={Images.progressLoader} style={styles.loaderImage} />
    //   ) : // <BufferingView style={styles.bufferView} />
    //   null;
    // };

    // const showThumbnail = !isVideoLoaded;
    return (
      <TouchableOpacity
        activeOpacity={1}
        onPress={() => controlFeedVolume(!videoVolumme)}>
        <View>
          {/* {!showThumbnail ? ( */}
          <InViewPort onChange={() => handlePlaying}>
            <Video
              ref={(ref: Video) => {
                videoPlayer = ref;
              }}
              source={{
                uri:
                  source?.uri ?? require('../../../assets/videos/Juggling.mp4'),
                cache: {size: 50, expiresIn: 3600},
              }}
              style={style ? style : styles.video}
              resizeMode="cover"
              repeat
              cache
              bufferConfig={{
                minBufferMs: 15000, //number
                maxBufferMs: 50000, //number
                bufferForPlaybackMs: 2500, //number
                bufferForPlaybackAfterRebufferMs: 5000, //number
              }}
              controls={false}
              onBuffer={() => {
                console.log('video is buffering');
              }}
              muted={videoVolumme}
              fullscreenOrientation="landscape"
              onLoad={onLoad}
              onProgress={onProgress}
              progressUpdateInterval={1000}
              onReadyForDisplay={data => onLoadVideo(data)}
              onVideoLoad={() => {
                console.log('video is loading');
              }}
              onLoadStart={() => (
                <Text style={{backgroundColor: 'red'}}>Video Loading</Text>
              )}
              shouldPlay
            />
          </InViewPort>
          {/* ) : ( */}
          {/* <Image source={thumbnail} height={350} width={'100%'} /> */}
          {/* )} */}

          <View style={styles.controlsView}>
            <View style={styles.bottomControls}>
              <RippleEffect
                onPress={() => controlFeedVolume(!videoVolumme)}
                style={styles.controlIcons}>
                <CustomIcon
                  name={videoVolumme ? Icons.SoundOff : Icons.SoundOn}
                  size={Metrics.largeFont}
                  color={Colors.textLight}
                />
              </RippleEffect>
              {/* <Slider
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
                }}
              /> */}
              <View style={styles.slider}></View>
              <CustomText style={styles.timerContainer}>
                <Text style={{padding: 1}}>{timeLeft}</Text>
              </CustomText>
            </View>
          </View>
        </View>
      </TouchableOpacity>
    );
  },
);
const mapStateToProps = state => ({
  videoVolumme: state.feedPostReducer.mute,
});

const mapDispatchToProps = dispatch => {
  return {
    controlFeedVolume: (...args) => {
      dispatch(controlVolume(...args));
    },
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(FeedVideoPlayer);
