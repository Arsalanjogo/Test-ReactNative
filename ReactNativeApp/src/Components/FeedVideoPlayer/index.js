import React, {useState, useRef, useEffect} from 'react';
import {
  View,
  Text,
  ImageBackground,
  Image,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import Video from 'react-native-video';
import {Colors, Metrics} from '../../Theme';
import {RippleEffect, CustomIcon, CustomText} from '../index';
import {Icons} from '../../Utils';
import styles from './styles';
import Slider from '@react-native-community/slider';
import * as Animatable from 'react-native-animatable';
import {connect} from 'react-redux';
// import {controlVolume} from '../../Store/FeedPost/actions';
import {concatImageUrl} from '../../Utils/Helpers';
function FeedVideoPlayer({
  source = '',
  style = {},
  id,
  itemId,
  index,
  mute,
  thumbnail,
  videoVolumme,
  controlFeedVolume,
  isVisible = false,
}) {
  const [paused, setPaused] = useState();
  const [fullScreen, setFullScreen] = useState(false);
  const [isSliding, setSliding] = useState(false);
  const [duration, setDuration] = useState(0);
  const [progress, setProgress] = useState(0);
  const [currentTime, setCurrentTime] = useState('00:00');
  const videoPlayer = useRef(null);
  const [timeLeft, setTimeLeft] = useState('0:00');
  const [opacity, setOpacity] = useState(false);
  const [thumbnailHeight, setThumbnailHeight] = useState(200);
  const [lastTap, setLastTap] = useState(null);
  // console.log("idsss", itemId, paused, index)
  useEffect(() => {
    setPaused(!isVisible);
    videoPlayer.current.seek(0);
  }, [isVisible]);
  // useEffect(() => {
  //     if (thumbnail) {

  //         Image.getSize(
  //             thumbnail,
  //             (width, height) => {
  //                 console.log(height)
  //                 setThumbnailHeight(Math.ceil(height * Metrics.width) / width);

  //             },
  //             () => {
  //                 // setWidth(w);
  //                 // setHeight(w);
  //                 setThumbnailHeight(200)
  //             },
  //         );
  //     }

  // }, [])
  //npm
  // console.log(source)
  const onLoad = data => {
    let time = data.duration;
    let minutes = Math.floor(time / 60);
    let seconds = parseInt(time - minutes * 60);
    if (seconds.toString().length == 1) seconds = '0' + seconds;
    setDuration(data.duration);
    // console.log(`${minutes}:${seconds}`)
    setTimeLeft(`${minutes}:${seconds}`);
  };

  const onProgress = data => {
    const {currentTime} = data;
    let time = (duration - currentTime).toFixed(2);
    // console.log(currentTime, duration, "data")
    if (time > 0) {
      let minutes = Math.floor(time / 60);
      let seconds = parseInt(time - minutes * 60);
      if (seconds.toString().length == 1) seconds = '0' + seconds;
      let height = currentTime / duration;
      setProgress(height);
      setCurrentTime(currentTime);
      // console.log(`${minutes}:${seconds}`)
      setTimeLeft(`${minutes}:${seconds}`);
    }
  };

  const onBuffering = ({isBuffering}) => {
    setOpacity(isBuffering);
    // console.log(isBuffering, isVisible, paused, id, "bufff")
  };

  const handleVolume = () => {
    const now = Date.now();
    const DOUBLE_PRESS_DELAY = 2000;

    if (lastTap && now - lastTap < DOUBLE_PRESS_DELAY) {
      controlFeedVolume(!videoVolumme);
      // console.log("likes")
    } else {
      setLastTap(now);
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
  // console.log(videoPlayer.current, "reff")
  return (
    <TouchableOpacity
      activeOpacity={1}
      onPress={() => controlFeedVolume(!videoVolumme)}>
      <View style={styles.container}>
        {!fullScreen ? (
          <>
            <Video
              ref={videoPlayer}
              source={source ? {...source, cacheName: 'StevesCache'} : null}
              style={style ? style : [opacity ? {opacity: 1} : 0, styles.video]}
              resizeMode="cover"
              repeat={true}
              controls={false}
              onBuffer={onBuffering}
              poster={thumbnail}
              // onLoadStart={() => console.log("loadinnn")}
              muted={videoVolumme}
              paused={paused}
              fullscreenOrientation="landscape"
              posterResizeMode="cover"
              onLoad={onLoad}
              onProgress={onProgress}
              progressUpdateInterval={1000}
            />
            {opacity && (
              <>
                <ImageBackground
                  style={{
                    width: '100%',
                    height: '100%',
                    zIndex: 2,
                  }}
                  source={{uri: thumbnail}}></ImageBackground>
                <ActivityIndicator
                  animating
                  size="large"
                  color={Colors.backgroundDark}
                  style={{
                    position: 'absolute',
                    top: 150,
                    left: 70,
                    right: 70,
                    height: 50,
                  }}
                />
              </>
            )}
          </>
        ) : null}

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
}

// const mapStateToProps = state => ({
//   videoVolumme: state.feedPostReducer.mute,
// });

// const mapDispatchToProps = dispatch => {
//   return {
//     controlFeedVolume: (...args) => {
//       dispatch(controlVolume(...args));
//     },
//   };
// };

export default connect(null, null)(FeedVideoPlayer);
