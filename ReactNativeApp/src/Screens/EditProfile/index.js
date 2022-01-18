import {Text, View, Image, TouchableOpacity, Keyboard} from 'react-native';
import React, {Component} from 'react';

import {
  RootView,
  Button,
  CustomText,
  Header,
  TextInput,
  DropDown,
  CustomIcon,
  DatePicker,
} from '../../Components';
import styles from './styles';
import {Icons, Navigator, showToast} from '../../Utils';
import {PermissionsAndroid} from 'react-native';
import {PERMISSIONS, RESULTS} from 'react-native-permissions';

import ImagePicker from 'react-native-image-crop-picker';
import Avatar from '../../../assets/images/avatar.png';
import moment from 'moment';
import {Colors} from '../../Theme';
import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';
import {connect} from 'react-redux';

class EditProfile extends Component {
  constructor(props) {
    super(props);
    this.state = {
      fname: '',
      lname: '',
      email: '',
      keyboardHeight: 0,
      selectedGender: {id: 1, name: 'male'},
      genders: [
        {id: 1, name: 'male'},
        {id: 2, name: 'female'},
        {id: 3, name: 'other'},
      ],
      showGenders: false,
      DOBPicker: false,
      DOB: new Date(),
      fnameError: false,
      lnameError: false,
      emailError: false,
      image: '',
    };
    this.inputs = {};
  }

  onChange(name, val) {
    this.setState({[name]: val});
  }

  focusNextField(id) {
    this.inputs[id].focus();
  }

  onKeyboardDidShow(e) {
    this.setState({keyboardHeight: e.endCoordinates.height});
  }

  onKeyboardDidHide() {
    this.setState({keyboardHeight: 0});
  }

  componentDidMount() {
    Keyboard.addListener('keyboardDidShow', e => this.onKeyboardDidShow(e));
    Keyboard.addListener('keyboardDidHide', e => this.onKeyboardDidHide(e));
  }

  // componentWillUnmount() {
  //   Keyboard.removeListener('keyboardDidShow', e => this.onKeyboardDidShow(e));
  //   Keyboard.removeListener('keyboardDidHide', e => this.onKeyboardDidHide(e));
  // }

  toggleCheck = () => {
    this.setState(prevState => ({
      checked: !prevState.checked,
    }));
  };

  uploadImage = async () => {
    const granted =
      (await Platform.OS) == 'android'
        ? PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.CAMERA)
        : PERMISSIONS.IOS.LOCATION_ALWAYS;

    if (
      (granted === Platform.OS) == 'android'
        ? PermissionsAndroid.RESULTS.GRANTED
        : RESULTS.GRANTED
    ) {
      ImagePicker.openPicker({
        width: 300,
        height: 300,
        cropping: true,
        includeBase64: true,
      })
        .then(image => {
          this.setState({
            image: image,
            imageSource: {uri: `data:${image.mime};base64,${image.data}`},
          });
        })
        .catch(err => {
          alert(err.message);
        });
    } else {
      alert('Permission Required');
    }
  };


  render() {
    const {
      fnameError,
      lnameError,
      emailError,
      email
    } = this.state;
    return (
      <RootView>
        <Header showRightIcon={false} title={'Edit Profile'} />
        <KeyboardAwareScrollView
          showsVerticalScrollIndicator={false}
          enableOnAndroid={true}
          keyboardShouldPersistTaps="handled"
          bounces={false}
          contentContainerStyle={{
            paddingBottom: -this.state.keyboardHeight - 50,
          }}
          extraScrollHeight={Platform.OS == 'android' && 50}
          style={{flex: 1}}>
          <View style={styles.topView}>
            <Image
              onPress={this.uploadImage}
              resizeMode="contain"
              source={Avatar}
              style={styles.avatar}
            />
            {this.state.imageSource && (
              <TouchableOpacity
                onPress={this.uploadImage}
                style={styles.cameraIconView}>
                <CustomIcon
                  size={25}
                  name={Icons.Photo}
                  color="black"
                  style={styles.cameraIcon}
                />
              </TouchableOpacity>
            )}
            {!this.state.imageSource && (
              <CustomText style={styles.addText} onPress={this.uploadImage}>
                ADD PROFILE PICTURE
              </CustomText>
            )}
          </View>

          <View style={styles.inputView}>
            <TextInput
              maxLength={20}
              required
              placeholder={'Please write your first name'}
              label={'FIRST NAME*'}
              returnKeyType="next"
              error={fnameError && true}
              errorMessage={'This is a required field'}
              textValue={this.state.fname}
              onRef={ref => {
                this.inputs['fname'] = ref;
              }}
              onChangeText={text => {
                this.onChange('fname', text.replace(/[^A-Za-z]+/g, ''));
              }}
              onSubmitEditing={() => {
                this.focusNextField('lname');
              }}
            />

            <TextInput
              maxLength={20}
              required
              placeholder={'Please write your last name'}
              label={'LAST NAME*'}
              returnKeyType="next"
              error={lnameError && true}
              errorMessage={'This is a required field'}
              textValue={this.state.lname}
              onRef={ref => {
                this.inputs['lname'] = ref;
              }}
              onChangeText={text => {
                this.onChange('lname', text.replace(/[^A-Za-z]+/g, ''));
              }}
              onSubmitEditing={() => {
                this.focusNextField('email');
              }}
            />

            <DatePicker
              labelStyle={{color: Colors.white}}
              iconStyle={{color: Colors.white}}
              inputText={{color: Colors.white}}
              label={'Date Of Birth'}
              selectedItem={this.state.DOB}
              placeholder={'Enter Date Of Birth'}
              onRef={ref => {
                this.datePicker = ref;
              }}
              onSelect={(event, date) => {
                this.setState({dobVisible: false, DOB: date});
              }}
              onClose={() => this.setState({DOBPicker: false})}
              onOpen={() => this.setState({DOBPicker: true})}
              visible={this.state.DOBPicker}
            />

            <DropDown
              // labelStyling={{
              //   color:
              //     error && !selectedEventCategory.id ? Color.error : Color.white,
              // }}
              label={'Select Gender*'}
              selectedItem={this.state.selectedGender}
              onOpen={() => this.setState({showGenders: true})}
              onClose={() => this.setState({showGenders: false})}
              data={this.state.genders}
              visible={this.state.showGenders}
              onSelect={item => {
                this.setState({selectedGender: item});
              }}
            />

                <TextInput
                  required
                  placeholder={'Please write your email'}
                  label={'EMAIL*'}
                  returnKeyType="next"
                  error={emailError && true}
                  errorMessage={'This is a required field'}
                  textValue={this.state.email}
                  onRef={ref => {
                    this.inputs['email'] = ref;
                  }}
                  onChangeText={text => {
                    this.onChange('email', text.replace(/\s/g, ''));
                  }}
                  onSubmitEditing={() => {
                    this.focusNextField('password');
                  }}
                />
          </View>
          
          <Button
            title={'SAVE'}
            style={styles.button}
            loading={this.state.loading}
          />
        </KeyboardAwareScrollView>
      </RootView>
    );
  }
}

export default connect(null, {})(EditProfile);
