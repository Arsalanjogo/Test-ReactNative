import React from 'react';
import {View} from 'react-native';

import {ButtonView, Image, Text, Swiper} from '../../../Components';
import {Images, Util} from '../../../Utils';
import {Colors} from '../../../Theme';

import styles from './styles';

const Logo = () => (
  <View style={styles.logoContainer}>
    <Image source={Images.Icons.postLogo} style={styles.logo} />
    <Text type="bold">{'433'}</Text>
  </View>
);

const RenderPost = ({post, isLiked}) => (
  <Swiper data={post} pagination={Pagination} />
);

const Pagination = (index, total) => {
  const items = [];
  for (let i = 0; i < total; i += 1) {
    items.push(
      <View
        style={[
          styles.dot,
          {backgroundColor: i === index ? Colors.primary : Colors.white},
        ]}
        key={i}
      />,
    );
  }

  return (
    <View style={styles.likeCommentContainer}>
      <ButtonView>
        <Image style={styles.like} source={Images.Icons.like} />
      </ButtonView>
      <ButtonView>
        <Image source={Images.Icons.comment} />
      </ButtonView>

      <View style={styles.dotsContainer}>{total < 2 ? null : items}</View>

      <ButtonView>
        <Image source={Images.Icons.share} />
      </ButtonView>
    </View>
  );
};

const TotalLikesAndViews = ({likes, views}) => {
  const like = likes > 1 ? 'Likes' : 'Like';
  const view = views > 1 ? 'Views' : 'View';
  return (
    <View style={styles.totalLikesViewsContainer}>
      {like > 0 && (
        <Text onPress={() => {}} type="bold">{`${likes} ${like}`}</Text>
      )}
      {like > 0 && <View style={styles.likesViewsSeparator} />}
      <Text onPress={() => {}} type="bold">{`${views} ${view}`}</Text>
    </View>
  );
};

const Caption = ({caption}) => <Text style={styles.desc}>{caption}</Text>;

const ViewAllComments = ({noOfComments}) => {
  return (
    <Text type="bold" color={Colors.black20} style={styles.viewComments}>
      {`View all ${noOfComments} comment`}
    </Text>
  );
};

const TimeAgo = ({createdAt}) => (
  <Text style={styles.timeAgo}>{Util.timeFromNow(createdAt)}</Text>
);

const Item = ({item}) => {
  const {
    totalComments,
    caption,
    totalLikes,
    totalViews,
    createdAt,
    isLiked,
    id,
    assets,
  } = item;
  return (
    <View style={styles.container}>
      <Logo />
      <RenderPost post={assets} isLiked={isLiked} />
      <View style={styles.bottomContainer}>
        {totalLikes > 0 ||
          (totalViews > 0 && (
            <TotalLikesAndViews likes={totalLikes} views={totalViews} />
          ))}
        {caption !== '' && <Caption caption={caption} />}
        {totalComments > 10 ? (
          <ViewAllComments noOfComments={totalComments} />
        ) : null}
        <TimeAgo createdAt={createdAt} />
      </View>
    </View>
  );
};

export default Item;
