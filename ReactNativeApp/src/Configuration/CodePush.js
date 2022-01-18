import React from 'react';
import {Platform} from 'react-native';
import CodePush from 'react-native-code-push';
import Config from 'react-native-config';

const deploymentKey =
  Platform.OS == 'android'
    ? Config.ANDROID_CODEPUSH_KEY
    : Config.IOS_CODEPUSH_KEY;

const CODE_PUSH_OPTIONS = {
  checkFrequency: CodePush.CheckFrequency.MANUAL,
  installMode: CodePush.InstallMode.ON_NEXT_RESTART,
  mandatoryInstallMode: CodePush.InstallMode.ON_NEXT_RESTART,
};

const withCodePush = WrappedComponent => {
  class WrappedApp extends React.PureComponent {
    state = {
      downloading: false,
      installing: false,
      receivedBytes: 0,
      totalBytes: 0,
      isMandatory: false,
    };

    componentDidMount() {
      CodePush.checkForUpdate(deploymentKey).then(update => {
        if (!update) {
          console.log('APP IS ALREADY UP TO DATE!');
        } else {
          console.log('CODE PUSH UPDATE =>', update);
          if (update.isMandatory) {
            this.setState({isMandatory: true}, () => {
              CodePush.sync(
                {
                  deploymentKey: deploymentKey,
                  installMode: CodePush.InstallMode.ON_NEXT_RESTART,
                  mandatoryInstallMode: CodePush.InstallMode.ON_NEXT_RESTART,
                },
                this.codePushStatusDidChange,
                this.checkDownloadProgress,
              );
            });
          } else {
            this.setState({isMandatory: false}, () => {
              CodePush.sync(
                {
                  deploymentKey: deploymentKey,
                  installMode: CodePush.InstallMode.ON_NEXT_RESTART,
                  mandatoryInstallMode: CodePush.InstallMode.ON_NEXT_RESTART,
                },
                this.codePushStatusDidChange,
                this.checkDownloadProgress,
              );
            });
          }
        }
      });
    }

    codePushStatusDidChange = status => {
      // console.log('CODE PUSH STATUS', status);
      switch (status) {
        case CodePush.SyncStatus.CHECKING_FOR_UPDATE:
          //   console.log('Checking for updates.');
          break;
        case CodePush.SyncStatus.DOWNLOADING_PACKAGE:
          this.setState({downloading: true});
          // console.log('Downloading package.');
          break;
        case CodePush.SyncStatus.INSTALLING_UPDATE:
          this.setState({installing: true, downloading: false});
          // console.log('Installing update.');
          break;
        case CodePush.SyncStatus.UP_TO_DATE:
          this.setState({downloading: false, installing: false});
          // console.log('Up-to-date.');
          break;
        case CodePush.SyncStatus.UPDATE_INSTALLED:
          this.setState({downloading: false, installing: true});
          // console.log('Update installed.');
          break;
        case CodePush.SyncStatus.UNKNOWN_ERROR:
          // console.log('Error occurred while syncing.');
          this.setState({
            downloading: false,
            installing: false,
            isMandatory: false,
          });
          break;
      }
    };

    checkDownloadProgress = downloadProgress => {
      const {receivedBytes, totalBytes} = downloadProgress;
      this.setState({
        receivedBytes,
        totalBytes,
      });
    };

    render() {
      const {downloading, installing, receivedBytes, totalBytes, isMandatory} =
        this.state;

      return (
        <WrappedComponent
          isMandatory={isMandatory}
          downloading={downloading}
          installing={installing}
          receivedBytes={receivedBytes}
          totalBytes={totalBytes}
          onClose={() =>
            this.setState({
              downloading: false,
              installing: false,
              isMandatory: false,
            })
          }
        />
      );
    }
  }
  return CodePush(CODE_PUSH_OPTIONS)(WrappedApp);
};

export default withCodePush;
