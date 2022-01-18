import {Text, View, Image, TouchableOpacity, Keyboard} from 'react-native';
import React, {Component} from 'react';

import {
  RootView,
  Button,
  CustomText,
  Header,
  TextInput,
  ValidationItem,
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
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import DateTimePicker from '@react-native-community/datetimepicker';
import moment from 'moment';
import {Colors} from '../../Theme';
import {
  hasLowerCase,
  hasUpperCase,
  hasNumber,
  hasSpecialCharachter,
} from '../../Utils/Helpers';
import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';
import {AuthApi} from '../../Services';
import {validateEmail} from '../../Utils/Helpers';
// import {login} from '../../Store/Auth/actions';
import {connect} from 'react-redux';

class Register extends Component {
  constructor(props) {
    super(props);
    this.state = {
      fname: this.props.route.params.fname ? this.props.route.params.fname : '',
      lname: this.props.route.params.lname ? this.props.route.params.lname : '',
      email: this.props.route.params.email ? this.props.route.params.email : '',
      password: '',
      keyboardHeight: 0,
      checked: false,
      selectedGender: {id: 1, name: 'male'},
      genders: [
        {id: 1, name: 'male'},
        {id: 2, name: 'female'},
        {id: 3, name: 'other'},
      ],
      showGenders: false,

      DOBPicker: false,
      DOB: new Date(),
      hasLowerCase: false,
      hasUpperCase: false,
      hasNumber: false,
      hasSpecialCharachter: false,
      fnameError: false,
      lnameError: false,
      emailError: false,
      passwordError: false,
      image: '',
      isSocialLogin: this.props.route.params.isSocialLogin,
    };
    this.inputs = {};
  }

  socialRegister = () => {
    const {fname, lname, selectedGender, image, DOB, email, isSocialLogin} =
      this.state;
    if (fname === '')
      this.setState({
        fnameError: true,
        lnameError: false,
        emailError: false,
        passwordError: false,
      });
    if (lname === '')
      this.setState({
        fnameError: false,
        lnameError: true,
        emailError: false,
        passwordError: false,
      });
    if (email === '')
      this.setState({
        fnameError: false,
        lnameError: false,
        emailError: true,
        passwordError: false,
      });

    this.setState({loading: true});
    AuthApi.register({
      provider_id: this.props.route.params.providerId,
      first_name: fname,
      last_name: lname,
      email: email,
      gender: selectedGender.id,
      date_of_birth: moment(DOB).format('DD/MM/YYYY'),
      username: this.props.route.params.userName,
      profile_picture: image,
    })
      .then(res => res.json())
      .then(response => {
        this.setState({loading: false});
        console.log(response, 'API RES');
        if (response.statusCode === 200) {
          Navigator.navigate('EmailValidation', {email: this.state.email});
          this.setState({loading: false});
          console.log(response, 'API RES');
        } else {
          showToast(response.message);
          this.setState({loading: false});
        }
      })
      .catch(err => {
        this.setState({loading: false});
        console.log(response, 'API RES');
        showToast('Network request failed');
      });
  };

  register = () => {
    let {login} = this.props;
    const {
      fname,
      lname,
      selectedGender,
      image,
      DOB,
      email,
      password,
      hasLowerCase,
      hasUpperCase,
      hasSpecialCharachter,
      hasNumber,
      checked
    } = this.state;
    if (fname === '')
      this.setState({
        fnameError: true,
      });
      if (fname != '')
      this.setState({
        fnameError: false,
      });  
    if (lname === '')
      this.setState({
        lnameError: true,
      });
      if (lname != '')
      this.setState({
        lnameError: false,
      });
    if (email === '')
      this.setState({
        emailError: true,
      });
      if (email != '')
      this.setState({
        emailError: false,
      });
    if (password === '')
      this.setState({ 
        passwordError: true,
      });
      if (password != '')
      this.setState({ 
        passwordError: false,
      });
    if (!validateEmail(email)) return showToast('Please enter valid email');
    if(!checked) return showToast('Please accept the policy')
    if (hasLowerCase && hasUpperCase && hasSpecialCharachter && hasNumber && checked) {
      this.setState({loading: true});
      const payload = {
        first_name: fname,
        last_name: lname,
        email: email,
        password: password,
        gender: selectedGender.id,
        date_of_birth: moment(DOB).format('YYYY-MM-DD'),
        username: this.props.route.params.userName,
      };
      AuthApi.register(payload)
        .then(res => res.json())
        .then(response => {
          this.setState({loading: false});
          if (response.statusCode === 200) {
            Navigator.navigate('EmailValidation', {email: this.state.email});
            this.setState({loading: false});
          } else {
            showToast(response.message);
            this.setState({loading: false});
          }
        })
        .catch(err => {
          this.setState({loading: false});
          showToast(err.message);
        });
    }
  };

  validatePassword = str => {
    this.setState({
      hasLowerCase: hasLowerCase(str),
      hasUpperCase: hasUpperCase(str),
      hasSpecialCharachter: hasSpecialCharachter(str),
      hasNumber: hasNumber(str),
    });
  };

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


  isImageSizePermitted =  (size_in_bytes) => {
    // bytes to megabyte conversion - where 1 MB = 1000000 bytes
    let size_in_mb = size_in_bytes / 1000000
    if(size_in_mb > 6){
      return false
    }
    return true
  }

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
          // console.log("image size_in_mb: ",size_in_mb);
          if(!this.isImageSizePermitted(image?.size)) return alert("Image cannot be larger than 3Mb")
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
      hasLowerCase,
      hasNumber,
      hasSpecialCharachter,
      hasUpperCase,
      fnameError,
      lnameError,
      emailError,
      passwordError,
      isSocialLogin,
      email
    } = this.state;

    console.log(email,validateEmail(email),"EMAIL VALIDATION")
    return (
      <RootView>
        <Header showRightIcon={false} title={'Personal Information'} />
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
              source={this.state.imageSource ? this.state.imageSource : Avatar}
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

            {/* <View style={styles.dobView}>
              <CustomText style={styles.dobLabel}>DATE OF BIRTH</CustomText>
              <TouchableOpacity
                onPress={() => this.setState({DOBPicker: true})}
                style={styles.dobInput}>
                <CustomText>
                  {moment(this.state.DOB).format().slice(0, 10)}
                </CustomText>
                <CustomIcon
                  name={Icons.Down}
                  size={25}
                  color={Colors.primary}
                  style={styles.dobIcon}
                />
              </TouchableOpacity>
            </View> */}

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

            {!isSocialLogin && (
              <>
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

                <TextInput
                  passwordEye
                  required
                  placeholder={'Please write your password'}
                  label={'PASSWORD*'}
                  returnKeyType="next"
                  error={passwordError && true}
                  errorMessage={'This is a required field'}
                  textValue={this.state.password}
                  secureTextEntry={true}
                  onRef={ref => {
                    this.inputs['password'] = ref;
                  }}
                  onChangeText={text => {
                    this.onChange('password', text);
                    this.validatePassword(text);
                  }}
                />
              </>
            )}
          </View>
          {!isSocialLogin && (
            <>
              <View style={styles.validationView}>
                <CustomText style={styles.validationTitle}>
                  Complete these password requirements:
                </CustomText>

                <ValidationItem
                  validated={hasLowerCase ? true : false}
                  title="One lowercase character"
                />
                <ValidationItem
                  validated={hasUpperCase ? true : false}
                  title="One uppercase character"
                />
                <ValidationItem
                  validated={hasNumber ? true : false}
                  title="One number"
                />
                <ValidationItem
                  validated={hasSpecialCharachter ? true : false}
                  title="One special character"
                />
                <ValidationItem
                  validated={this.state.password.length >= 8 ? true : false}
                  title="Min. eight character"
                />
              </View>
            </>
          )}

          <View style={styles.agreeView}>
            <TouchableOpacity style={styles.box} onPress={this.toggleCheck}>
              {this.state.checked ? (
                <Icon name={'check'} color={'white'} size={15} />
              ) : null}
            </TouchableOpacity>
            <View>
              <Text style={styles.whiteText}>
                I have read and agree to 433's{' '}
                <Text
                  onPress={() => Navigator.navigate('TermsAndCondition')}
                  style={styles.yellowText}>
                  Terms {`&`}
                </Text>
              </Text>
              <Text style={styles.whiteText}>
                <Text
                  style={styles.yellowText}
                  onPress={() => Navigator.navigate('TermsAndCondition')}>
                  Conditions{' '}
                </Text>
                and
                <Text
                  style={styles.yellowText}
                  onPress={() => Navigator.navigate('PrivacyPolicy')}>
                  {' '}
                  Privacy Policy
                </Text>
              </Text>
            </View>
          </View>
          <Button
            title={'CONTINUE'}
            style={styles.button}
            onPress={isSocialLogin ? this.socialRegister : this.register}
            loading={this.state.loading}
          />
        </KeyboardAwareScrollView>
      </RootView>
    );
  }
}

export default connect(null, null)(Register);
