import {Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {CustomText, RootView, Header} from '../../Components';
// import {logout} from '../../Store/Auth/actions'
import {connect} from 'react-redux';

const More = props => {
  const [value, setValue] = useState('');

  onLogout = () => {
    let {logout} = props;
    logout();
  };

  return (
    <RootView bottom={0}>
      <Header showLeftIcon={false} showRightIcon={false} title={'More'} />

      <CustomText onPress={this.onLogout}>Logout</CustomText>
    </RootView>
  );
};

export default connect(null, null)(More);
