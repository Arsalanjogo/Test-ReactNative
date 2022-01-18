import React from 'react';
import {enableScreens} from 'react-native-screens';
import {NavigationContainer} from '@react-navigation/native';
import {
  createStackNavigator,
  CardStyleInterpolators,
  TransitionPresets,
} from '@react-navigation/stack';

import {
  Games,
  GameDetail,
  GameResult,
  GameRecording,
  ViewsLikes,
  Login,
  LoginOptions,
  Register,
  PickUsername,
  ResetPassword,
  TermsAndCondition,
  CreateNewPassword,
  PrivacyPolicy,
  OTPCode,
  EmailValidation,
  ShareWithFriends,
} from '../Screens';
import BottomTab from './BottomTab';
import {DataHandler, Navigator, Util} from '../Utils';
import {authSelectors} from '../ducks/auth';
// import GmailLogin from '../Utils/GmailLogin';

enableScreens();

// useEffect(() => {
//   GmailLogin.configureGoogleSignIn();
//   // if (user) {
//   //   setLogin(true);
//   // } else {
//   //   setLogin(false);
//   // }
//   // setLoading(false);
//   // console.log(user, "USER")
// });

const RootStack = createStackNavigator();
const Stack = createStackNavigator();

const AppStack = () => {
  const user = authSelectors.getUser(DataHandler.getStore().getState());

  let initialState = 'LoginOptions';
  if (!Util.isEmpty(user)) {
    initialState = 'Home';
  }

  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        cardStyleInterpolator: CardStyleInterpolators.forHorizontalIOS,
      }}
      initialRouteName={initialState}>
      <Stack.Screen name="Login" component={Login} />
      <Stack.Screen name="LoginOptions" component={LoginOptions} />
      <Stack.Screen name="Register" component={Register} />
      <Stack.Screen name="PickUsername" component={PickUsername} />
      <Stack.Screen name="ResetPassword" component={ResetPassword} />
      <Stack.Screen name="TermsAndCondition" component={TermsAndCondition} />
      <Stack.Screen name="CreateNewPassword" component={CreateNewPassword} />
      <Stack.Screen name="PrivacyPolicy" component={PrivacyPolicy} />
      <Stack.Screen name="OTPCode" component={OTPCode} />
      <Stack.Screen name="EmailValidation" component={EmailValidation} />

      <Stack.Screen name="Home" component={BottomTab} />
      <Stack.Screen name="Games" component={Games} />
      <Stack.Screen name="GameDetail" component={GameDetail} />
      <Stack.Screen name="GameResult" component={GameResult} />
      <Stack.Screen name="GameRecording" component={GameRecording} />
      <Stack.Screen name="ViewsLikes" component={ViewsLikes} />
      <Stack.Screen
        name="ShareWithFriends"
        component={ShareWithFriends}
        options={{...TransitionPresets.ModalSlideFromBottomIOS}}
      />
    </Stack.Navigator>
  );
};

const App = () => {
  return (
    <NavigationContainer
      ref={navigatorRef => {
        Navigator.setTopLevelNavigator(navigatorRef);
      }}>
      <RootStack.Navigator mode="modal">
        <RootStack.Screen
          name="Main"
          component={AppStack}
          options={{headerShown: false}}
        />
      </RootStack.Navigator>
    </NavigationContainer>
  );
};

export default App;
