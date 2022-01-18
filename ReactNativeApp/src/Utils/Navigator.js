import {CommonActions, StackActions} from '@react-navigation/native';

let _navigator;
let currentRoute = 'Home';

function setTopLevelNavigator(navigatorRef) {
  _navigator = navigatorRef;
}

function navigate(routeName, params, stackName) {
  if (stackName) {
    _navigator.navigate(stackName, {screen: routeName, params});
  } else {
    _navigator.navigate(routeName, params);
  }
}

function replace(routeName, params) {
  _navigator.dispatch(StackActions.replace(routeName, params));
}

function push(routeName, params) {
  _navigator.dispatch(StackActions.push(routeName, params));
}

function pop(number = 1) {
  _navigator.dispatch(StackActions.pop(number));
}

function popToTop() {
  _navigator.dispatch(StackActions.popToTop());
}

function getNavigator() {
  return _navigator;
}

function reset(routeName, params = {}) {
  // _navigator.dispatch(
  //   StackActions.reset({
  //     index: 0,
  //     actions: [NavigationActions.navigate({ routeName })],
  //   }),
  // );

  const resetAction = CommonActions.reset({
    index: 0,
    routes: [{name: routeName, params}],
  });
  _navigator.dispatch(resetAction);
}

function setCurrentRoute(route) {
  currentRoute = route;
}

function getCurrentRoute() {
  return currentRoute;
}

function goBack(routeName, params) {
  _navigator.dispatch(CommonActions.goBack());
}

// add other navigation functions that you need and export them

export default {
  navigate,
  goBack,
  replace,
  push,
  pop,
  setTopLevelNavigator,
  setCurrentRoute,
  getCurrentRoute,
  getNavigator,
  reset,
  popToTop,
};
