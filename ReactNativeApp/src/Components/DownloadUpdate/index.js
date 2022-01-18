import React from 'react';
import {View, Text, Modal, StyleSheet} from 'react-native';
import {Colors, Fonts, Metrics} from '../../Theme';
import * as Progress from 'react-native-progress';
import CodePush from 'react-native-code-push';
import Button from '../Shared/Button';

export default function DownloadUpdates({
  downloading,
  installing,
  receivedBytes,
  totalBytes,
  onClose,
  isMandatory,
}) {
  const received = (parseFloat(receivedBytes) / 1024000).toFixed(2);
  const total = (parseFloat(totalBytes) / 1024000).toFixed(2);
  const progress = parseFloat(parseFloat(received / total).toFixed(2)) || 0;

  return (
    <Modal
      animationType="fade"
      transparent={true}
      visible={(downloading && isMandatory) || installing}>
      <View style={styles.centeredView}>
        <View style={styles.modalView}>
          {downloading && isMandatory ? (
            <>
              <Text style={styles.heading}>
                {downloading ? 'Downloading Updates' : 'Installing Updates'}
              </Text>
              <Text style={styles.text}>Download progress</Text>
              <Text style={styles.text}>
                {received} MB / {total} MB
              </Text>
              <Progress.Bar
                progress={progress}
                height={14}
                width={Math.round(Metrics.width * 0.6)}
                color={Colors.primary}
                style={{marginVertical: 10, alignSelf: 'center'}}
              />
            </>
          ) : installing ? (
            <>
              <Text style={styles.heading}>
                New updates are ready to be installed!
              </Text>
              <Text style={styles.text}>
                Restart app to install updates and get the latest version of the
                app!
              </Text>
              <View style={styles.buttonContainer}>
                <Button
                  title="Restart now"
                  style={{marginVertical:15}}
                  onPress={() => CodePush.restartApp()}
                />
                {!isMandatory && (
                  <Button
                    title="Later"
                    style={{backgroundColor:Colors.textLight}}
                    onPress={onClose}
                  />
                )}
              </View>
            </>
          ) : null}
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#7d7d7d85',
  },
  modalView: {
    borderRadius: 20,
    overflow: 'hidden',
    width: '90%',
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
    borderColor: 'gray',
    elevation: 5,
    backgroundColor: Colors.backgroundDark,
    padding: 20,
  },
  heading: {
    fontSize: 24,
    fontFamily: Fonts.primaryBold,
    textAlign: 'center',
    marginBottom: 20,
    color: 'white',
  },
  text: {
    textAlign: 'center',
    fontSize: 16,
    fontFamily: Fonts.primary,
    marginBottom: 10,
    letterSpacing: 0.54,
    lineHeight: 24,
    color: 'white',
  }
});
