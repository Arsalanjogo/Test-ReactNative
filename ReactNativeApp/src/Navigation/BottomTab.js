import React from 'react';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import Home from '../Screens/Home';
import More from '../Screens/More';
import Games from '../Screens/Games';
import TabBarComponent from '../Components/TabBarComponent';
import {Icons} from '../Utils';
const Tab = createBottomTabNavigator();
const icons = {
  Home: Icons.Home,
  Play: Icons.Media,
  Videos: Icons.Play,
  Games: Icons.Game,
  Menu: Icons.More1,
};

export default function HomeTabs() {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
      }}
      tabBar={props => <TabBarComponent icons={icons} {...props} />}
      initialRouteName="Home"
      tabBarOptions={{
        keyboardHidesTabBar: true,
        showLabel: false,
      }}>
      <Tab.Screen name="Home" component={Home} />
      <Tab.Screen name="Play" component={Games} />
      <Tab.Screen name="Videos" component={Games} />
      <Tab.Screen name="Games" component={Games} />
      <Tab.Screen name="Menu" component={More} />
    </Tab.Navigator>
  );
}
