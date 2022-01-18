import * as React from 'react';
import {
  createStackNavigator,
  CardStyleInterpolators,
} from '@react-navigation/stack';
import Login from '../Screens/Login';
import LoginOptions from '../Screens/LoginOptions';
import Register from '../Screens/Register';
import PickUsername from '../Screens/PickUsername';
import ResetPassword from '../Screens/ResetPassword';
import TermsAndCondition from '../Screens/TermsAndCondition';
import CreateNewPassword from '../Screens/CreateNewPassword';
import PrivacyPolicy from '../Screens/PrivacyPolicy';
import OTPCode from '../Screens/OTPCode';
import EmailValidation from '../Screens/EmailValidation';

const Stack = createStackNavigator();

const AuthStack = () => (
  <Stack.Navigator
    initialRouteName="LoginOptions"
    screenOptions={{
      headerShown: false,
      cardStyleInterpolator: CardStyleInterpolators.forHorizontalIOS,
    }}>
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


  </Stack.Navigator>
);

export default AuthStack;
