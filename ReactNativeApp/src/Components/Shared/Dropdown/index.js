import React, {Component} from 'react';
import {View, FlatList, Text, TouchableOpacity, Modal} from 'react-native';
import styles from './styles';
import {Colors, Metrics, Fonts} from '../../../Theme';
import {Icons, Navigator} from '../../../Utils';
import {CustomIcon} from '../../index';

class DropDown extends Component {
  constructor(props) {
    super(props);
    this.state = {
      visible: false,
    };
  }

  onSelect = item => {
    let {multi, selectedItem, onSelect, onClose} = this.props;

    if (multi) {
      let index = selectedItem.indexOf(item.id);
      if (index > -1) {
        selectedItem.splice(index, 1);
        onSelect([...selectedItem]);
      } else {
        onSelect([...selectedItem, item.id]);
      }
    } else {
      onSelect(item);
      onClose();
    }
  };

  renderSelectedValue = () => {
    let {multi, selectedItem, placeholder, data} = this.props;
    if (selectedItem) {
      if (multi) {
        let result = '';
        for (let i = 0; i < data.length; i++) {
          if (selectedItem.includes(data[i].id)) result += `${data[i].name}, `;
          if (i === data.length - 1) result = result.slice(0, -2);
        }
        return result;
      }
      return selectedItem.name ? selectedItem.name : selectedItem.title;
    }
    return placeholder;
  };

  renderItem = (item, index) => {
    let {multi, selectedItem} = this.props;
    return (
      <TouchableOpacity onPress={() => this.onSelect(item)} activeOpacity={0.7}>
        <View
          style={{...styles.listItem, borderTopWidth: index == 0 ? 0 : 0.5}}>
          <Text style={styles.listText}>{item.name || item.title}</Text>
          {/* {item.flag ? (
            <ImageView
              style={{width: 35, height: 35}}
              imageUrl={concatImageUrl(item.flag)}
            />
          ) : null}
          {multi && (
            <View style={styles.iconView}>
              {selectedItem.includes(item.id) && (
                <Icon
                  iconName={'MaterialIcons'}
                  name="check"
                  size={20}
                  color={Color.black}
                />
              )}
            </View>
          )} */}
        </View>
      </TouchableOpacity>
    );
  };

  render() {
    const {
      label,
      data,
      onClose,
      visible,
      onOpen,
      selectedItem,
      inputStyling = {},
      labelStyling = {},
      seletedColor = 'white',
      multi,
      disabled = false,
      onSelectAll = () => {},
      allSelected = false,
      selectAll = false,
    } = this.props;
    return (
      <View style={{marginBottom: 25}}>
        <Text style={[styles.label, labelStyling]}>{label}</Text>
        <TouchableOpacity
          onPress={onOpen}
          activeOpacity={0.9}
          disabled={disabled}>
          <View style={[styles.dropdown, inputStyling]}>
            <View style={{flex: 0.9}}>
              <Text
                numberOfLines={1}
                style={[
                  styles.dropdownText,
                  {color: selectedItem ? seletedColor : Colors.primary},
                ]}>
                {this.renderSelectedValue()}
              </Text>
            </View>
            <View style={{flex: 0.1, alignItems: 'flex-end'}}>
              <CustomIcon name={Icons.Down} size={25} color={Colors.primary} />
            </View>
          </View>
        </TouchableOpacity>
        <View>
          <Modal
            visible={visible}
            onRequestClose={onClose}
            transparent={true}
            animationType="fade">
            <View style={styles.centeredView}>
              <View
                style={[
                  styles.modalView,
                  {...(data.length > 2 && {minHeight: 250})},
                ]}>
                <View style={styles.modalHeader}>
                  <Text style={styles.heading}>{label}</Text>
                  <View style={{flexDirection: 'row', alignItems: 'center'}}>
                    {selectAll ? (
                      <TouchableOpacity
                        onPress={onSelectAll}
                        style={styles.iconView}>
                        {allSelected && (
                          <CustomIcon
                            name={Icons.check}
                            size={20}
                            color={'red'}
                          />
                        )}
                      </TouchableOpacity>
                    ) : (
                      <CustomIcon
                        name={Icons.Close}
                        style={styles.icon}
                        onPress={onClose}
                        color={'red'}
                      />
                    )}
                  </View>
                </View>
                <FlatList
                  data={data}
                  extraData={this.props}
                  keyExtractor={() => JSON.stringify(Math.random().toString())}
                  renderItem={({item, index}) => this.renderItem(item, index)}
                  style={styles.list}
                />
                {selectAll ? (
                  <Text style={styles.close} onPress={onClose}>
                    Close
                  </Text>
                ) : null}
              </View>
            </View>
          </Modal>
        </View>
      </View>
    );
  }
}

export default DropDown;
