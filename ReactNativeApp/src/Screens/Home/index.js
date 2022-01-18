import React, {useState, useCallback} from 'react';
import {View} from 'react-native';
import {
  Text,
  Header,
  RootView,
  Loader,
  FlatListApi,
  FeedsPost,
} from '../../Components';
import {feedPostReducer} from '../../Store';
import {Images} from '../../Utils';
import {useSelector} from 'react-redux';
import {Colors, Metrics} from '../../Theme';
import {authSelectors} from '../../ducks/auth';
import {homeActions, homeSelectors} from '../../ducks/home';
import {IDENTIFIERS} from '../../Config/Constants';
import {requestFlagSelectors} from '../../ducks/requestFlags';

import Item from './Item';

const Home = () => {
  // const [allPosts, setAllPosts] = useState([]);
  const [viewedItems, setViewedItems] = useState([]);
  const [viewedId, setViewedId] = useState();
  // const [offset, setOffset] = useState(0);
  // const [loading, setLoading] = useState(true);

  // const isUserLogin = useSelector(authSelectors.isUserLogin);

  const data = useSelector(homeSelectors.getPosts);

  // useEffect(() => {
  //   if (isUserLogin) {
  //     getPosts();
  //   }
  // }, [isUserLogin]);

  // useEffect(() => {
  //   setAllPosts(posts);
  // }, [posts]);

  const viewConfigRef = React.useRef({itemVisiblePercentThreshold: 90});

  const onViewRef = React.useRef(({viewableItems, changed}) => {
    setViewedId(
      ...changed
        .filter(({index, isViewable, item}) => isViewable)
        .map(({item}) => item.id),
    );
    setViewedItems(oldViewedItems => {
      // console.log(
      //   '[handleVieweableItemsChanged] new viewable:',
      //   ...changed
      //     .filter(({ index, isViewable, item }) => isViewable)
      //     .map(({ item }) => item.id)
      // );

      // console.log(changed, "changed")
      let newViewedItems = null;

      changed.forEach(({index, item, isViewable}) => {
        if (
          item.id != null &&
          isViewable &&
          !oldViewedItems.includes(item.id)
        ) {
          if (newViewedItems == null) {
            newViewedItems = [...oldViewedItems];
          }
          newViewedItems.push(item.id);
        }
        if (item?.assets.length == 1) {
          if (
            item?.assets[0]?.fileName?.includes('mp4') &&
            !oldViewedItems.includes(item.id)
          ) {
            createView(item.id);
          }
        }
      });

      // If the items didn't change, we return the old items so
      //  an unnecessary re-render is avoided.
      return newViewedItems == null ? oldViewedItems : newViewedItems;
    });
  });

  const requestFlags = useSelector(
    requestFlagSelectors.getRequestFlag(`HOME_${IDENTIFIERS.HOME_LISTING}`),
  );

  const renderItem = useCallback(
    ({item}) => <Item item={item} />,
    // <FeedsPost item={item} isVisible={viewedId == item.id.toString()} />
    [viewedId],
  );

  const keyExtractor = useCallback(item => item.id.toString(), []);

  const emptyView = () => (
    <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
      <Text>No Post Found</Text>
    </View>
  );

  //   // setLoading(true)
  //   setOffset(0)

  //   getPosts(0)

  // }
  return (
    <RootView bottom={0}>
      <Header search />
      <FlatListApi
        // viewabilityConfig={viewConfigRef.current}
        // onViewableItemsChanged={onViewRef.current}
        updateCellsBatchingPeriod={10}
        showsVerticalScrollIndicator={false}
        windowSize={5}
        maxToRenderPerBatch={5}
        contentContainerStyle={{paddingHorizontal: 0, paddingTop: 0}}
        data={data}
        keyExtractor={keyExtractor}
        renderItem={renderItem}
        requestAction={homeActions.requestHome}
        requestFlags={requestFlags}
        identifier={IDENTIFIERS.HOME_LISTING}
        emptyView={emptyView}
      />
    </RootView>
  );
};

export default Home;
