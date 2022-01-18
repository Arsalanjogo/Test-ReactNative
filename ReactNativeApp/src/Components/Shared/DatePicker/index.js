import React, {Component} from 'react';
import {View, Text, TouchableOpacity, Modal, Platform} from 'react-native';
import {Colors, Fonts, Metrics} from '../../../Theme';
import styles from './styles';
import DatePickerr from 'react-native-datepicker';
import DateTimePicker from '@react-native-community/datetimepicker';
import CustomIcon from '../CustomIcon';
import moment from 'moment';
import {Icons} from '../../../Utils'

class DatePicker extends Component {
  state = {
    openTimePicker: false,
    time: Date.now(),
  };
  render() {
    const {
      label,
      onSelect,
      selectedItem,
      onRef = () => {},
      style,
      timePicker,
      error = false,
      labelStyle = {},
      inputStyle = {},
      inputText = {},
      disabledPreviousDates = false,
    } = this.props;
    let {openTimePicker} = this.state;
    return (
      <View style={{ ...style}}>
        <Text
          style={[
            styles.dobLabel,
            {color: !error ? Colors.white : Colors.error},
            labelStyle,
          ]}>
          {label}
        </Text>
        {!timePicker ? (
          <>
            <DatePickerr
              ref={input => {
                this.DatePicker = input;
                onRef(input);
              }}
              style={styles.dobInput}
              date={
                selectedItem ? moment(selectedItem).format('DD-MM-YYYY') : ''
              }
              minDate={
                disabledPreviousDates
                  ? moment(Date.now()).format('DD-MM-YYYY')
                  : undefined
              }

              maxDate={moment(Date.now()).format('DD-MM-YYYY')}
              mode="date"
              format="DD-MM-YYYY"
              confirmBtnText={"Confirm"}
              cancelBtnText={"Cancel"}
            //   placeholder={"Select Date"}
              showIcon={true}
              customStyles={{
                datePickerCon: {},
                datePicker: {
                  justifyContent: 'center',
                },
                dateInput: [ styles.dropdown,inputStyle],
                placeholderText: {...styles.dropdownText},
                dateText: [styles.dropdownText, inputText],
                btnTextConfirm: {
                  color: Colors.secondary,
                },
                btnTextCancel: {
                  color: Colors.secondary,
                },
              }}
              onDateChange={onSelect}
              iconComponent={
                <CustomIcon
                  name={Icons.Down}
                  size={25}
                  style={styles.dropdownIcon}
                  color={Colors.primary}
                />
              }
            />
          </>
        ) : (
          <>
            <TouchableOpacity
              onPress={() => {
                this.setState({openTimePicker: true});
              }}
              style={[
                {
                  backgroundColor: Colors.base,
                  alignItems: 'center',
                  flexDirection: 'row',
                  justifyContent: 'space-between',
                  paddingHorizontal: 10,
                  borderRadius: 8,
                  height: Metrics.height * 0.06,
                },
                inputStyle,
              ]}>
              <Text
                style={{
                  fontFamily: Fonts.primary,
                  fontSize: Metrics.defaultFont,
                  color: Colors.white,
                  marginHorizontal: 16,
                }}>
                {moment(selectedItem).format("hh:mm A")}
              </Text>
              <CustomIcon
                name={Icons.Down}
                size={Icons.smallSize}
                color={Colors.primary}
              />
            </TouchableOpacity>
            {Platform.OS == 'android' ? (
              <>
                {openTimePicker && (
                  <DateTimePicker
                    display="default"
                    testID="dateTimePicker"
                    value={selectedItem || Date.now()}
                    mode={'time'}
                    onChange={(event, selectedDate) => {
                      if (event.type === 'dismissed') {
                        this.setState({openTimePicker: false});
                      } else {
                        this.setState({openTimePicker: false});
                        onSelect(selectedDate);
                      }
                    }}
                  />
                )}
              </>
            ) : (
              <Modal transparent={true} visible={openTimePicker}>
                <TouchableOpacity
                  activeOpacity={1}
                  onPress={() => this.setState({openTimePicker: false})}
                  style={{flex: 1, justifyContent: 'center'}}>
                  <View
                    style={{
                      justifyContent: 'center',
                      height: 230,
                      backgroundColor: 'white',
                      width: '90%',
                      alignSelf: 'center',
                      shadowColor: '#000',
                      shadowOffset: {
                        width: 0,
                        height: 2,
                      },
                      shadowOpacity: 0.25,
                      shadowRadius: 3.84,
                      borderRadius: 20,
                    }}>
                    <DateTimePicker
                      display="default"
                      testID="dateTimePicker"
                      value={selectedItem || Date.now()}
                      mode={'time'}
                      onChange={(event, selectedDate) => {
                        if (event.type === 'dismissed') {
                          this.setState({openTimePicker: false});
                        } else {
                          this.setState({openTimePicker: false});
                          onSelect(selectedDate);
                        }
                      }}
                    />
                  </View>
                </TouchableOpacity>
              </Modal>
            )}
          </>
        )}
      </View>
    );
  }
}

export default DatePicker;