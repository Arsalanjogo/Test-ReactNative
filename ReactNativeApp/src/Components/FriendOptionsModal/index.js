import React, { Component } from 'react';
import { View , Modal, StatusBar,TouchableOpacity} from 'react-native';
import { MaterialIndicator } from 'react-native-indicators';
import { CustomText } from '..';
import { Colors } from '../../Theme';
import styles from './styles';

class FriendsOptionsModal extends Component {

  modalButton = (title,textStyle, onPress) => {
    return(
      <TouchableOpacity onPress={onPress} style={styles.modalButton}>
        <CustomText style={textStyle}>{title}</CustomText>
      </TouchableOpacity>
    )
  }

  render() {
    const {visible, onCancel, onUnfriend, onBlock, onShare} = this.props;
    return (
      <Modal
            animationType="fade"
            transparent={true}
            visible={visible}
        >
            <View style={{ flex: 1, alignItems: "center", justifyContent: 'flex-end', backgroundColor: '#00000d85' }}>
                <StatusBar backgroundColor='rgb(162,66,67)' />
                <View style={styles.buttonView}>
                {this.modalButton("Unfriend Friend Name",styles.redText,onUnfriend)}
                {this.modalButton("Block Friend Name",styles.redText,onBlock)}
                {this.modalButton("Share Profile",styles.modalButtonText,onShare)}
                {this.modalButton("Cancel",styles.modalButtonText,onCancel)}
                </View>
            </View>
        </Modal>
    );
  }
}

export default FriendsOptionsModal;