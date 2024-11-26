import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../utilities/logger.dart';

class AuthService {
  Future<User?> signInWithGoogle() async {
    try {
      NerdLogger.logger.d('Google sign-in started');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        NerdLogger.logger.d('Google sign-in aborted');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _getUser(credential);
    } catch (e) {
      NerdLogger.logger.e('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<User?> _getUser(credential) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    NerdLogger.logger.i('Sign-in successful: ${user?.email}');
    return user;
  }


  Future<User?> signInWithApple() async {
    try {
      NerdLogger.logger.d('Apple sign-in started');
      final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ]
      );
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _getUser(oAuthCredential);
    }
    catch (e) {
      NerdLogger.logger.e('Error during Apple sign-in: $e');
      return null;
    }
  }
}
