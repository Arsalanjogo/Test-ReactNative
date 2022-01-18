import React, {useState, useCallback, useEffect} from 'react';
import {View, Text} from 'react-native';
import {connect} from 'react-redux';
import moment from 'moment';

function PostsDetail({item, expand, posts, liked}) {
  const NUM_OF_LINES = 2;
  const [description, setDescription] = useState('');
  const [loadMore, setLoadMore] = useState(false);
  const [textLines, setTextLines] = useState(0);
  const [numberOfLines, setNumberOfLines] = useState(0);
  const onLoadMoreToggle = () => {
    // expand(!loadMore, id);
    setLoadMore(!loadMore);
  };

  const onTextLayout = useCallback(e => {
    if (textLines == 0) setTextLines(e.nativeEvent.lines.length);
  });
  useEffect(() => {
    if (item) {
      setDescription(item);
    }
  }, [item, posts]);

  useEffect(() => {
    setNumberOfLines(loadMore ? NUM_OF_LINES : textLines);
  }, [loadMore]);

  return description ? (
    <View style={styles.container}>
      {/* ${item?.caurosel[0]?.mediaType == "video" ? ` | 125 Views` : ''}`} */}

      <CustomText bold style={styles.textStyle}>
        {description.totalLikes > 0 && (
          <>
            {' '}
            <Text
              onPress={() => {
                Navigator.navigate('ViewsLikes', {
                  id: item.id,
                  totalLikes: description.totalLikes,
                });
              }}>{`${description.totalLikes}  ${
              description.totalLikes > 1 ? 'Likes' : 'Like'
            } `}</Text>{' '}
          </>
        )}
        {description.totalViews > 0 && description.totalLikes > 0 && (
          <Text style={{fontFamily: Fonts.primary}}> | </Text>
        )}
        {description.totalViews > 0 &&
          item?.assets.length == 1 &&
          item?.assets[0]?.fileName.includes('mp4') && (
            <>
              <Text
                onPress={() => {
                  Navigator.navigate('Views', {
                    id: item.id,
                    totalViews: description.totalViews,
                  });
                }}>
                {`${description.totalViews}  ${
                  description.totalViews > 1 ? 'Views' : 'View'
                } `}
              </Text>
            </>
          )}
      </CustomText>

      {/* <View style={loadMore && { flexDirection: "row" }}>


                <CustomText style={styles.captionFont} numberOfLines={loadMore ? NUM_OF_LINES : textLines} onTextLayout={onTextLayout}>
                    {details.detail}

                </CustomText>
                {(textLines >= numberOfLines) &&
                    <Text style={loadMore && { alignSelf: "flex-end" }}>

                        <TouchableWithoutFeedback onPress={onLoadMoreToggle}>
                            <Text style={styles.moreText}>{loadMore && 'More'}</Text>
                        </TouchableWithoutFeedback>

                    </Text>
                }

            </View> */}
      {description.caption != '' && (
        <TextCutter
          style={styles.captionFont}
          text={description.caption}
          limit={105}></TextCutter>
      )}
      <CustomText style={styles.commentTextStyle}>
        View all {168} comments
      </CustomText>
      <CustomText style={styles.timeStyle}>{`${moment(
        description.createdAt,
      ).format('HH')} hours ago`}</CustomText>
    </View>
  ) : (
    <></>
  );
}

const mapStateToProps = state => {
  return {
    posts: state.feedPostReducer.posts,
  };
};

export default connect(mapStateToProps)(PostsDetail);
