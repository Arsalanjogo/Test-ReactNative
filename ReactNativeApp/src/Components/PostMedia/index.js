import React, {useState, useEffect, useRef, memo} from 'react';
import {
  View,
  TouchableOpacity,
  Image,
  Text,
  ActivityIndicator,
} from 'react-native';
import {ImageView, CustomIcon, FeedVideoPlayer} from '..';
import styles from './styles';
import Carousel, {Pagination} from 'react-native-snap-carousel';
import {Colors, Images, Metrics} from '../../Theme';
import {Icons, Navigator} from '../../Utils';
import Icon from 'react-native-vector-icons/Ionicons';

// import {setLike} from '../../Store/FeedPost/actions';
import Button from '../Shared/Button';
import {concatImageUrl} from '../../Utils/Helpers';
import {connect} from 'react-redux';
import {setLike} from '../../Store/FeedPost/actions';
import Swiper from 'react-native-swiper';
function PostMedia({post, isVisible = false, setIsLike, liked, setLiked}) {
  let isCarousel = useRef(null);
  const [carouselItems, setCauroselItems] = useState([]);
  const [activeIndex, setActiveIndex] = useState(0);
  // const [liked, setLiked] = useState(0);
  const [lastTap, setLastTap] = useState(null);
  const [timeLeft, setTimeLeft] = useState('0:00');
  const [imageSize, setImageSize] = useState('');
  const [swiper, startSwiper] = useState(true);
  useEffect(() => {
    if (post) {
      setCauroselItems(post.assets);
      // console.log(post.isLiked, "likess???")
      setLiked(post.isLiked);
    }
  }, [post]);
  useEffect(() => {
    setTimeout(() => {
      startSwiper(true);
    }, 500);
  }, []);

  const _renderItem = item => {
    if (item) {
      // console.log(item, "assets")

      return (
        <TouchableOpacity
          onPress={() => handleDoubleTap(post.id)}
          activeOpacity={0.9}>
          {!item?.fileName?.includes('mp4') ? (
            <ImageView
              resizeMode="cover"
              originalSize={!Boolean(imageSize)}
              style={
                Boolean(imageSize) && {
                  width: Metrics.width,
                  height: imageSize.height,
                }
              }
              setImageSize={!Boolean(imageSize) ? setImageSize : () => {}}
              imageUrl={concatImageUrl(item.url)}
            />
          ) : (
            <View style={styles.videoContainer}>
              <FeedVideoPlayer
                id={post.id}
                itemId={item.id}
                index={activeIndex}
                thumbnail={concatImageUrl(item.thumbnailUrl)}
                isVisible={isVisible}
                timeLeft={timeLeft}
                setTimeLeft={setTimeLeft}
                style={styles.videoStyle}
                source={{uri: concatImageUrl(item.url)}}
              />
            </View>
          )}
        </TouchableOpacity>
      );
    }
  };

  const pagination = () => {
    // console.log(activeIndex, "index active")
    return (
      <View style={styles.paginationButtons}>
        <Pagination
          dotsLength={carouselItems.length}
          activeDotIndex={activeIndex}
          containerStyle={{
            backgroundColor: 'rgba(0, 0, 0, 0.75)',
            marginRight: Metrics.largeMargin,
          }}
          dotStyle={{
            width: 7,
            height: 7,
            borderRadius: 5,
            margin: -3.2,
            backgroundColor: Colors.primary,
          }}
          inactiveDotStyle={{
            backgroundColor: Colors.backgroundLight,
          }}
          inactiveDotOpacity={0.6}
          inactiveDotScale={1}
        />
      </View>
    );
  };

  const handleDoubleTap = id => {
    const now = Date.now();
    const DOUBLE_PRESS_DELAY = 200;

    if (lastTap && now - lastTap < DOUBLE_PRESS_DELAY) {
      setLastTap(null);
      toggleLike(id);

      // console.log("likes")
    } else {
      setLastTap(now);
    }
  };

  const toggleLike = id => {
    setIsLike(!liked, id);
    setLiked(!liked);
  };
  // console.log(post)
  return post ? (
    <View>
      {/* <Swiper data={carouselItems} /> */}
      <View
        style={{
          marginLeft: Metrics.defaultMargin,
          marginBottom: Metrics.smallMargin,
          flexDirection: 'row',
          alignItems: 'center',
          alignContent: 'center',
        }}>
        <Image style={{height: 34.31}} source={Images.icons.logo433} />
        <Text style={styles.userStyle}>433</Text>
      </View>
      {swiper && (
        <Swiper
          style={styles.slideDefault}
          showsButtons={false}
          width={Metrics.width}
          showsPagination={false}
          renderPagination={pagination}
          // dotColor={"white"}
          // activeDotColor='yellow'
          index={activeIndex}
          loadMinimal={true}
          loadMinimalSize={2}
          automaticallyAdjustContentInsets
          key={carouselItems.length}
          height={imageSize.height ? imageSize.height : 370}
          removeClippedSubviews={false}
          data={carouselItems}
          loop={false}
          bounces={true}
          // scrollsToTop={true}

          loadMinimalLoader={
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
          }
          onIndexChanged={index => setActiveIndex(index)}
          ref={c => (isCarousel = c)}>
          {carouselItems.map(item => _renderItem(item))}
        </Swiper>
      )}

      {/* <Carousel
        data={carouselItems}
        renderItem={_renderItem}
        activeSlideOffset={0}
        inactiveSlideScale={1}
        decelerationRate={0}
        scrollEndDragDebounceValue={0}
        // enableMomentum={true}
        // removeClippedSubviews={true}
        loopClonesPerSide={carouselItems.length}
        enableSnap={true}
        swipeThreshold={2}
        ref={c => isCarousel = c}
        sliderWidth={Metrics.width}
        itemWidth={Metrics.width}
        onSnapToItem={(index) => setActiveIndex(index)}
      /> */}

      <View style={styles.outerContainer}>
        <View style={styles.iconContainer}>
          {/* {liked ? <Icon name="heart" color={Colors.primary} onPress={toggleLike} style={styles.iconLike} /> : <CustomIcon name={Icons.Like} onPress={toggleLike} color={Colors.light} style={styles.customIconLike} />} */}
          <Icon
            name={liked ? 'heart' : 'heart-outline'}
            color={liked ? Colors.primary : Colors.light}
            onPress={() => toggleLike(post.id)}
            style={styles.iconLike}
          />
          <CustomIcon
            name={Icons.Comment}
            color={Colors.light}
            style={styles.icon}
          />
        </View>
        {pagination()}
        <View>
          <CustomIcon
            onPress={() => Navigator.navigate('ShareWithFriends')}
            name={Icons.Share2}
            color={Colors.light}
            style={[styles.icon, {marginBottom: 2}]}
          />
        </View>
      </View>

      <Button
        title="View Now"
        textStyle={{fontSize: Metrics.defaultFont * 0.8}}
        secondary
        backgroundStyle={{
          paddingTop: Metrics.defaultMargin * 0.2,
          paddingBottom: Metrics.defaultMargin * 0.5,
          paddingHorizontal: Metrics.defaultMargin * 0.6,
        }}
        style={{height: Metrics.height * 0.055, marginTop: 0}}
        onPress={() => {}}
      />
    </View>
  ) : (
    <></>
  );
}

// const mapStateToProps = () => {};
// const mapDispatchToProps = dispatch => {
//   return {
//     setIsLike: (...args) => {
//       dispatch(setLike(...args));
//     },
//   };
// };

export default connect(null, null)(PostMedia);
