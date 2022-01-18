import React, {useState} from 'react';
import {View, FlatList, Image, Text, TouchableOpacity} from 'react-native';
import {
  Button,
  CustomText,
  Header,
  Loader,
  RootView,
  TextInput,
} from '../../Components';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import {Colors, Images, Metrics} from '../../Theme';
import styles from './styles';
import {Icons, Navigator} from '../../Utils';
const ShareWithFriends = () => {
  const DATA = [
    {
      id: 0,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 1,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 2,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 3,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 4,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 5,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 6,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
    {
      id: 7,
      image: Images.images.userImage,
      firstName: 'Lorem Ipsum',
      username: 'username',
      checked: false,
    },
  ];
  const [dummyData, setToggleCheckBox] = useState(DATA);
  const [focus, setFocus] = useState(false);
  const [value, setValue] = useState('');
  const [message, setMessage] = useState('');
  const emptyView = () => {
    const image = value == '' ? null : Images.emptyIcons.search;
    return (
      <View
        style={{
          justifyContent: 'center',
          alignItems: 'center',
        }}>
        <Image source={image} style={{marginBottom: 24}} />
        <CustomText>No Account found.</CustomText>
      </View>
    );
  };
  const Item = ({item}) => {
    const {
      profilePicture, // change name from pciture to picture (backend)
      firstName,
      lastName,
      username,
      checked,
      id,
    } = item;
    const handleCheck = index => {
      var items = [...dummyData];
      const item = {...items[index]};
      item.checked = !checked;
      items[index] = item;
      setToggleCheckBox(items);
    };
    return (
      <View style={styles.itemContainer}>
        <Image
          source={Images.images.userImage}
          //   source={
          //     profilePicture === '' ? Images.icons.dummyUserImage : profilePicture
          //   }
          style={styles.userImage}
        />
        <View style={styles.nameContainer}>
          <CustomText bold style={styles.name}>
            {firstName}
          </CustomText>
          <CustomText style={styles.username}>{username}</CustomText>
        </View>
        <TouchableOpacity
          onPress={() => handleCheck(id)}
          activeOpacity={0.8}
          style={[
            styles.checkBox,
            {
              backgroundColor: checked ? Colors.primary : Colors.darkGray,
            },
          ]}>
          <Icon
            name={checked ? 'check' : null}
            size={21}
            color={Colors.backgroundDark}
          />
        </TouchableOpacity>
      </View>
    );
  };
  //   const handleFocus = bool => {
  //     setFocus(bool);
  //   };
  const onChangeText = value => {
    setValue(value);
  };
  const onChangeMessage = value => {
    setMessage(value);
  };
  var checkToggle = dummyData.some(data => data.checked === true);
  return (
    <>
      <RootView>
        <Header
          // iconView={{alignItems: 'flex-start'}}
          title={'Share with Friends'}
          leftIcon={null}
          rightIcon={Icons.Close}
          onPressRight={() => Navigator.goBack()}
        />
        <View style={styles.container}>
          <TextInput
            //   onFocus={handleFocus}
            value={value}
            placeholder="Search Friends"
            customStyle={styles.searchBar}
            rightIconPress={() => {
              value !== '' && setValue('');
            }}
            rightIcon={value == '' ? Images.icons.search : Images.icons.cross}
            onChangeText={onChangeText}
          />
          <FlatList
            style={styles.flatlistStyle}
            showsVerticalScrollIndicator={false}
            data={dummyData}
            renderItem={Item}
            keyExtractor={item => item.id.toString()}
            // onEndReached={loadmore}
            // onEndReachedThreshold={0.1}
            ListEmptyComponent={emptyView}
          />
        </View>
        <View
          style={[
            {
              height: checkToggle
                ? (20 / 100) * Metrics.height
                : (10 / 100) * Metrics.height,
            },
            styles.modalView,
          ]}>
          {checkToggle ? (
            <View style={styles.childView}>
              <TextInput
                value={message}
                placeholder="Write your message here."
                maxLength={2200}
                multiline={true}
                customStyle={styles.messageBox}
                rightIconPress={() => {
                  message !== '' && setMessage('');
                }}
                rightIcon={message == '' ? null : Images.icons.cross}
                onChangeText={onChangeMessage}
              />
            </View>
          ) : null}
          <View style={styles.childView}>
            <Button
              style={[
                styles.button,
                {
                  backgroundColor: checkToggle
                    ? Colors.primary
                    : Colors.placeholder,
                },
              ]}
              onPress={() => (checkToggle ? Navigator.goBack() : null)}
              title={'Share'}
              textStyle={styles.buttonText}
            />
          </View>
        </View>
      </RootView>
    </>
  );
};
export default ShareWithFriends;
