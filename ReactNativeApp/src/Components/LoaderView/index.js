// @flow
import Modal from 'react-native-modal';
import React from 'react';

import {View, StatusBar, ActivityIndicator} from 'react-native';
import {Colors} from '../../Theme';
import styles from './styles';
import {Util} from '../../Utils';

const LoaderView = () => {
  return (
    <>
      <StatusBar networkActivityIndicatorVisible={true} />
      <Modal
        useNativeDriver={Util.isPlatformAndroid()}
        style={styles.modal}
        backdropOpacity={0.4}
        animationIn="fadeIn"
        animationOut="fadeOut"
        isVisible={true}>
        <View style={styles.container}>
          <ActivityIndicator animating size="large" color={Colors.primary} />
        </View>
      </Modal>
    </>
  );
};

export default LoaderView;
