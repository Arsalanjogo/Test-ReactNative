// @flow
import React from 'react';
import {View, StatusBar, ActivityIndicator} from 'react-native';
import PropTypes from 'prop-types';
import {useSelector} from 'react-redux';
import Modal from 'react-native-modal';
import {getRequestFlag} from '../../../ducks/requestFlags/selectors';
import {Colors} from '../../../Theme';
import styles from './styles';
import {Util} from '../../../Utils';

const Loader = ({type, showSpinner}) => {
  const requestFlags = useSelector(getRequestFlag(type));
  const loading = requestFlags.loading || false;
  return loading ? (
    <View>
      <StatusBar networkActivityIndicatorVisible={loading} />
      <Modal
        useNativeDriver={Util.isPlatformAndroid()}
        style={styles.modal}
        backdropOpacity={showSpinner ? 0.4 : 0.1}
        animationIn="fadeIn"
        animationOut="fadeOut"
        isVisible={loading}>
        <View style={styles.container}>
          {showSpinner && (
            <ActivityIndicator animating size="large" color={Colors.primary} />
          )}
        </View>
      </Modal>
    </View>
  ) : null;
};

Loader.propTypes = {
  requestFlags: PropTypes.object,
  showSpinner: PropTypes.bool,
};

Loader.defaultProps = {requestFlags: {}, showSpinner: true};

export default React.memo(Loader);
