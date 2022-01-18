import * as React from 'react';
import {
  createStackNavigator,
  CardStyleInterpolators,
} from '@react-navigation/stack';

//Screen inports
import BottomTab from './BottomTab';
import Games from '../Screens/Games';
import GameDetail from '../Screens/GameDetail';
import GameResult from '../Screens/GameResult';
import GameRecording from '../Screens/GameRecording';
import Home from '../Screens/Home';
import MyProfile from '../Screens/MyProfile'
import EditProfile from '../Screens/EditProfile'
import OthersProfile from '../Screens/OthersProfile';
import NotificationsCenter from '../Screens/NotificationsCenter'

import ViewsLikes from '../Screens/ViewsLikes';
const Stack = createStackNavigator();

const AppStack = () => (
  <Stack.Navigator
    initialRouteName="Home"
    screenOptions={{
      headerShown: false,
      cardStyleInterpolator: CardStyleInterpolators.forHorizontalIOS,
    }}>
    <Stack.Screen name="Home" component={BottomTab} />
    <Stack.Screen name="Games" component={Games} />
    <Stack.Screen name="GameDetail" component={GameDetail} />
    <Stack.Screen name="GameResult" component={GameResult} />
    <Stack.Screen name="GameRecording" component={GameRecording} />
    {/* <Stack.Screen name="Likes" component={Likes} /> */}
    <Stack.Screen name="MyProfile" component={MyProfile} />
    <Stack.Screen name="EditProfile" component={EditProfile} />
    <Stack.Screen name="OthersProfile" component={OthersProfile} />
    <Stack.Screen name="NotificationsCenter" component={NotificationsCenter} />
    <Stack.Screen name="Likes" component={ViewsLikes} />
    <Stack.Screen name="Views" component={ViewsLikes} />
  </Stack.Navigator>
);

export default AppStack;
