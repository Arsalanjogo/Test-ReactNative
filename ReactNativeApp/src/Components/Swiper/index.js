import React from 'react';
import {View, Pressable} from 'react-native';
import Video from 'react-native-video';
import Swiper from 'react-native-swiper';

import {ImageViewHttp} from '..';
import {concatImageUrl} from '../../Utils/Helpers';
import {FILE_TYPE} from '../../Config/Constants';
import {Metrics} from '../../Theme';

import styles from './styles';

export default props => {
  const _renderItem = (item, index) => {
    let video = () => Video;

    const {url} = item;
    var period = url.lastIndexOf('.');
    var fileExtension = url.substring(period + 1);
    const isVideo =
      fileExtension.toLowerCase() === FILE_TYPE.VIDEO ? true : false;

    return (
      <Pressable
        onPress={() => {
          /* DOUBLE TAP FUNCTIONALITY */
        }}>
        <View style={styles.container}>
          {isVideo ? (
            <Video
              source={{uri: concatImageUrl(url), cache: true}}
              // repeat={true}
              ref={(ref: Video) => {
                video = ref;
              }}
              style={{
                position: 'absolute',
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                height: Metrics.height * 0.42,
                // width: Metrics.width,
              }}
              //   style
              //     ? style
              //     : [
              //         opacity ? {opacity: 1} : 0,
              //         {
              //           position: 'absolute',
              //           top: 0,
              //           bottom: 0,
              //           right: 0,
              //           left: 0,
              //         },
              //       ]
              // }
              resizeMode="cover"
              controls={false}
              // onBuffer={onBuffering}
              // poster={thumbnail}
              // onLoadStart={() => console.log("loadinnn")}
              // muted={videoVolumme}
              // paused={paused}
              fullscreenOrientation="landscape"
              posterResizeMode="cover"
              // onLoad={onLoad}
              // onProgress={onProgress}
              progressUpdateInterval={1000}
            />
          ) : (
            <ImageViewHttp url={concatImageUrl(url)} />
          )}
          {/* <ParallaxImage url={item} key={item} /> */}
        </View>
      </Pressable>
    );
  };

  const {data, pagination} = props;

  return data && data.length > 0 ? (
    <Swiper
      key={data.length}
      height={Metrics.height * 0.42}
      loop={false}
      renderPagination={pagination}>
      {data.map(_renderItem)}
    </Swiper>
  ) : (
    _renderItem({url: ''})
  );
};
