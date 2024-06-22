import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/utils/secure_token_storage.dart';
import 'package:portal_app/features/data/models/user_model.dart';

class AuthenRepository extends ChangeNotifier {
  AuthenRepository() {
    checkGoogleUser();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel? userInfoes;
  bool isChecked = false;
  bool isLogin = false;

  Future<void> checkGoogleUser() async {
    isLogin = await isSignedIn();

    if (isLogin) {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // save user info
        userInfoes = UserModel(
          displayName: googleUser.displayName,
          photoUrl: googleUser.photoUrl,
        );
      }
    }
    
    isChecked = true;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // save user info
        userInfoes = UserModel(
          displayName: googleUser.displayName,
          photoUrl: googleUser.photoUrl,
        );

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // save token
        Storage.token = {
          "idToken": googleAuth.idToken,
          "accessToken": googleAuth.accessToken,
        };
        await saveToken(Storage.token);

        isLogin = true;
        notifyListeners();
      }
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<void> signOut() async {
    Future.wait([
      _googleSignIn.signOut(),
    ]);

    // clear user info & token
    Storage.token = {};
    await deleteToken();
    userInfoes = null;
    isLogin = false;
    notifyListeners();
  }
}
