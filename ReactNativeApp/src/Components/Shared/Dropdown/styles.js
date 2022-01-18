import {StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../../Theme';

const {height, font} = Metrics;

export default StyleSheet.create({
  dropdown: {
    backgroundColor: Colors.backgroundDark,
    paddingHorizontal: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    height: Metrics.height * 0.060,
    color: Colors.light,
    borderWidth: 1.5,
    borderColor: 'white',
    borderRadius: Metrics.height * 0.04,
    marginHorizontal: Metrics.defaultMargin,
  },
  dropdownText: {
    color: Colors.textLight,
    fontFamily: Fonts.primary,
    fontSize: Metrics.defaultFont,
    textTransform: 'capitalize',
  },
  label: {
    fontSize: Metrics.smallFont,
    fontFamily: Fonts.primaryBold,
    textTransform: 'uppercase',
    color: Colors.light,
    marginLeft: Metrics.largeMargin,
    marginBottom: 3,
  },
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#2929294a',
    borderRadius: 8,
  },
  modalView: {
    borderRadius: 15,
    width: '75%',
    elevation: 5,
    backgroundColor: Colors.light,
    maxHeight: '60%',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  modalHeader: {
    paddingHorizontal: 20,
    paddingVertical: 15,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderTopStartRadius: 5,
    borderTopEndRadius: 5,
  },
  icon: {
    fontSize: 24,
  },
  checkAllicon: {
    fontSize: 22,
    marginRight: 10,
  },
  heading: {
    fontFamily: Fonts.primaryMedium,
    fontSize: 18,
    // color: Colors.white,
  },
  list: {
    paddingHorizontal: 20,
    backgroundColor: Colors.base,
  },
  listItem: {
    paddingVertical: 10,
    borderColor: Colors.darkGray,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  listText: {
    textTransform: 'capitalize',
    fontFamily: Fonts.primary,
    fontSize: Metrics.defaultFont,
    // color: Colors.white,
  },
  close: {
    color: Colors.primary,
    fontFamily: Fonts.primaryMedium,
    textAlign: 'center',
    padding: Metrics.defaultMargin,
    fontSize: 14,
  },
  iconView: {
    backgroundColor: Colors.primary,
    width: 35,
    borderRadius: 5,
    height: 35,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
