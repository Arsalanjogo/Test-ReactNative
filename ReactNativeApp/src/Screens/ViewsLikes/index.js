import React, {useEffect, useState} from 'react';
import {View, FlatList, Image} from 'react-native';
import {connect, useDispatch} from 'react-redux';
import {
  Button,
  CustomText,
  Header,
  Loader,
  RootView,
  TextInput,
} from '../../Components';
// import {
//   getTotalLikes,
//   getTotalViews,
// } from '../../Store/TotalViewsLikes/actions';
import {TotalViewsLikesApi} from '../../Services';
import {Icons, showToast} from '../../Utils';
import {Images} from '../../Theme';
import styles from './styles';
import {concatImageUrl} from '../../Utils/Helpers';

let timer = null;
const ViewsLikes = ({
  getTotalLikes,
  getTotalViews,
  likes,
  views,
  user,
  route,
  isLoading,
}) => {
  const [value, setValue] = useState('');
  const [likesData, setLikesData] = useState(likes);
  const [viewsData, setViewsData] = useState(views);
  // const [data, setData] = useState(dt)
  // const [offset, setOffset] = useState(0);
  const [filterData, setFilterData] = useState([]);
  const [addFriends, setAddFriends] = useState([]);
  const [loading, setLoading] = useState(true);

  const {id, totalLikes, totalViews} = route.params;

  useEffect(() => {
    totalLikes ? getTotalLikes(id) : getTotalViews(id);
  }, []);

  useEffect(() => {
    setLoading(isLoading);
  }, [isLoading]);

  useEffect(() => {
    setLikesData(likes);
  }, [likes]);
  useEffect(() => {
    console.log(views);
    setViewsData(views);
  }, [views]);

  const onPressButton = id => {
    let renderData = totalLikes ? [...likesData] : [...viewsData];
    let friends = [...addFriends];

    for (let data of renderData) {
      if (data.id == id) {
        data.selected = data.selected == null ? true : !data.selected;
        if (data.selected) {
          friends.push(data);
        } else {
          friends = arrayRemove(addFriends, data);
        }
        break;
      }
    }
    setLikesData(renderData);
    setAddFriends(friends);
  };

  const arrayRemove = (arr, value) => {
    return arr.filter(function (geeks) {
      return geeks != value;
    });
  };

  const Item = ({item}) => {
    const {
      profilePicture, // change name from pciture to picture (backend)
      firstName,
      lastName,
      userName,
      isFriend,
      selected,
      id,
    } = item;
    return (
      <View style={styles.itemContainer}>
        <Image
          source={
            profilePicture === '' ? Images.icons.dummyUserImage : profilePicture
          }
          style={styles.userImage}
        />
        <View style={styles.nameContainer}>
          <CustomText bold style={styles.name}>
            {`${firstName} ${lastName}`}
          </CustomText>
          <CustomText style={styles.username}>{userName}</CustomText>
        </View>
        {!isFriend && user.user.id !== id && (
          <Button
            secondary={selected}
            style={styles.button}
            onPress={() => onPressButton(id)}
            title={selected ? 'Requested' : 'Add Friend'}
            textStyle={styles.buttonText}
          />
        )}
      </View>
    );
  };
  const onSearch = async (id, value) => {
    try {
      const res = totalLikes
        ? await TotalViewsLikesApi.searchUser(id, value)
        : await TotalViewsLikesApi.searchViewedUser(id, value);
      const response = res.json();
      response
        .then(data => setFilterData(data.data))
        .catch(err => showToast(err.message));
    } catch (err) {
      showToast(err.message);
    }
  };

  const onChangeText = value => {
    setValue(value);
    clearTimeout(timer);
    if (value !== '') {
      timer = setTimeout(() => onSearch(id, value), 500);
    }
  };

  const like = totalLikes === 1 ? ' Like' : ' Likes';
  const view = totalViews === 1 ? ' View' : ' Views';
  const loadmore = () => {
    // setOffset(offset + 10, () => getTotalLikes(id, offset));
  };

  const emptyView = () => {
    const image = value == '' ? null : Images.emptyIcons.search;
    const title =
      value == ''
        ? totalLikes
          ? 'No Likes found.'
          : 'No Views found.'
        : 'No Account found.';
    return (
      <View
        style={{
          justifyContent: 'center',
          alignItems: 'center',
        }}>
        <Image source={image} style={{marginBottom: 24}} />
        <CustomText>{title}</CustomText>
      </View>
    );
  };

  return (
    <RootView >
      <Header
        style={{backgroundColor: 'black'}}
        iconView={{alignItems: 'flex-start'}}
        title={totalLikes ? 'Likes' : 'Views'}
        rightIcon={null}
      />
      <View style={styles.container}>
      <View style={styles.noOfLikesContainer}>
        <Image
          source={totalLikes ? Images.icons.heart : Images.icons.view}
          style={styles.heartIcon}
        />
        <CustomText bold style={styles.noOfLikes}>
          {totalLikes ? `${totalLikes} ${like}` : `${totalViews} ${view}`}
        </CustomText>
      </View>
      <TextInput
        value={value}
        placeholder="Search"
        customStyle={styles.searchBar}
        rightIconPress={() => {
          value !== '' && setValue('');
        }}
        rightIcon={value == '' ? Images.icons.search : Images.icons.cross}
        onChangeText={onChangeText}
      />

      {/* <View style={styles.itemContainer}>
        <Image source={Images.icons.dummyUserImage} style={styles.userImage} />
        <View style={styles.nameContainer}>
          <CustomText bold style={styles.name}>
            Hammad Abdul Wahab
          </CustomText>
          <CustomText style={styles.username}>Kandohi</CustomText>
        </View>
      </View> */}

      {loading ? (
        <Loader style={{marginBottom: Metrics.largeMargin}} />
      ) : (
        <FlatList
          style={styles.flatlistStyle}
          showsVerticalScrollIndicator={false}
          data={
            totalLikes
              ? value == ''
                ? likesData
                : filterData
              : value == ''
              ? viewsData
              : filterData
          }
          renderItem={Item}
          keyExtractor={item => item.id.toString()}
          onEndReached={loadmore}
          onEndReachedThreshold={0.1}
          ListEmptyComponent={emptyView}
        />
      )}
      </View>
      
    </RootView>
  );
};

// const mapStateToProps = state => {
//   return {
//     likes: state.totalViewsLikesReducer.likes,
//     views: state.totalViewsLikesReducer.views,
//     isLoading: state.totalViewsLikesReducer.isLoading,
//   };
// };

// const mapDispatchToProps = dispatch => {
//   return {
//     getTotalLikes: (...args) => {
//       dispatch(getTotalLikes(...args));
//     },
//     getTotalViews: (...args) => {
//       dispatch(getTotalViews(...args));
//     },
//   };
// };

export default connect(null, null)(ViewsLikes);
