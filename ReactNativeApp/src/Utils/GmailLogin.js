import {
  GoogleSignin,
  GoogleSigninButton,
  statusCodes,
} from '@react-native-google-signin/google-signin';
import {googleProfileRequestConfig} from './SocialLogin';

class GmailLogin {
    
  
  configureGoogleSignIn() {
    GoogleSignin.configure(googleProfileRequestConfig);
  }

  signInGoogle = async (onUserLogin, onUserFailure) => {
    try {
      await this.signOutGoogle();

      await GoogleSignin.hasPlayServices({
        showPlayServicesUpdateDialog: true,
      });

      const userInfo = await GoogleSignin.signIn();
      
      console.log({userInfo})
      if (onUserLogin) {
        onUserLogin(userInfo.user);
      } 
    } catch (error) {
      console.log('Google errorrrrr', error?.message);

      if (error.code === statusCodes.SIGN_IN_CANCELLED) {
        // user cancelled the login flow
        if (onUserFailure) {
          onUserFailure(error.code);
        }
      } else if (error.code === statusCodes.IN_PROGRESS) {
        // operation (f.e. sign in) is in progress already
        if (onUserFailure) {
          onUserFailure(error.code);
        }
      } else if (error.code === statusCodes.PLAY_SERVICES_NOT_AVAILABLE) {
        // play services not available or outdated
        if (onUserFailure) {
          onUserFailure(error.code);
        }
      } else if (onUserFailure) {
        // some other error happened
        onUserFailure(error.code);
      }
    }
  };

  signOutGoogle = async () => {
    const isSignedIn = await GoogleSignin.isSignedIn();

    if (isSignedIn) {
      try {
        //  await GoogleSignin.revokeAccess();
        await GoogleSignin.signOut();
      } catch (error) {
        console.error(error);
      }
    }
  };
}

export default new GmailLogin();
