import {StyleSheet} from 'react-native';
import {Colors, Metrics} from '../../Theme';
export default StyleSheet.create({
  container: {
    paddingHorizontal: 16,
    flex: 1,
  },
  searchBar: {
    marginHorizontal: 0,
  },
  checkBox: {
    height: 24,
    width: 24,
    borderRadius: 7,
    borderWidth: 1,
    borderColor: Colors.primary,
  },
  modalView: {
    backgroundColor: Colors.backgroundDark,
    // backgroundColor: 'lightyellow',
    width: Metrics.width,
  },
  childView: {
    height: (10 / 100) * Metrics.height,
    justifyContent: 'center',
  },
  messageBox: {
    width: (90 / 100) * Metrics.width,
  },
  button: {
    borderWidth: 0,
    height: 40,
    alignSelf: 'center',
    width: (90 / 100) * Metrics.width,
  },
  buttonText: {
    fontSize: 16,
    textTransform: 'uppercase',
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
});
