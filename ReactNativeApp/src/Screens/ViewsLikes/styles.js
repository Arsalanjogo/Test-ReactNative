import {StyleSheet} from 'react-native';

export default StyleSheet.create({
  container: {
    paddingHorizontal: 16,
    flex: 1,
  },
  flatlistContainer: {
    flex: 1,
  },
  searchBar: {
    marginHorizontal: 0,
  },
  noOfLikes: {
    fontSize: 12,
    lineHeight: 16,
  },
  noOfLikesContainer: {
    flexDirection: 'row',
    marginTop: 28,
    alignSelf: 'center',
    alignItems: 'center',
  },
  button: {
    height: 40,
  },
  buttonText: {
    fontSize: 12,
    textTransform: 'capitalize',
    paddingHorizontal: 10,
    paddingVertical: 0,
  },
  itemContainer: {
    flexDirection: 'row',
    paddingVertical: 4,
    alignItems: 'center',
  },
  userImage: {
    marginRight: 8,
    height: 64,
    width: 64,
    borderRadius: 64 / 2,
  },
  nameContainer: {
    flex: 1,
  },
  name: {
    lineHeight: 24,
    fontSize: 16,
  },
  username: {
    lineHeight: 24,
    fontSize: 12,
  },
  heartIcon: {
    marginRight: 11,
  },
});
