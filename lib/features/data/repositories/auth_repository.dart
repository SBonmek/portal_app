import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/utils/secure_token_storage.dart';
import 'package:portal_app/core/utils/show_error_snack_bar.dart';
import 'package:portal_app/features/data/models/token_model.dart';
import 'package:portal_app/features/data/models/user_profile_model.dart';
import 'package:portal_app/features/data/remotes/user_remote.dart';
import 'package:portal_app/features/data/repositories/news_repository.dart';
import 'package:portal_app/features/data/repositories/portal_repository.dart';
import 'package:provider/provider.dart';

class AuthRepository extends ChangeNotifier {
  // temp data
  bool isLoaded = false;
  bool isSignedIn = false;
  UserProfileModel? userProfile;

  // remote
  final UserRemote _userRemote = UserRemoteImpl();

  Future<void> checkToken(BuildContext context) async {
    isSignedIn = await _isSignedIn();

    if (isSignedIn) {
      try {
        final TokenResponse tokenResponse = await _userRemote.refreshingToken();

        // save user info
        Storage.token = TokenModel(
          idToken: tokenResponse.idToken!,
          accessToken: tokenResponse.accessToken!,
          refreshToken: tokenResponse.refreshToken!,
        );
        await saveToken(Storage.token!);
        userProfile = await _userRemote.getProfile();

        if (context.mounted) {
          context.read<NewsRepository>().getNewsList();
          context.read<PortalRepository>().getPortalList();
        }
      } catch (error) {
        print(error);
      }
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    try {
      isLoaded = false;
      isSignedIn = false;
      notifyListeners();

      final TokenResponse tokenResponse =
          await _userRemote.signInWithKeyCloak();

      // save token
      Storage.token = TokenModel(
        idToken: tokenResponse.idToken!,
        accessToken: tokenResponse.accessToken!,
        refreshToken: tokenResponse.refreshToken!,
      );
      await saveToken(Storage.token!);

      // save user info
      userProfile = await _userRemote.getProfile();

      // get new data
      if (context.mounted) {
        context.read<NewsRepository>().getNewsList();
        context.read<PortalRepository>().getPortalList();
      }

      isSignedIn = true;
    } catch (error) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          errorText: error.toString(),
        );
      }
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<bool> _isSignedIn() async {
    final token = await getToken();
    if (token != null) {
      DateTime currentDateTime = DateTime.now();
      DateTime expireTokenDateTime = await getExpireTokenDateTime();

      return currentDateTime.isBefore(expireTokenDateTime);
    }

    return false;
  }

  signOut(BuildContext context) {
    isLoaded = false;
    notifyListeners();

    //TODO request sign out
    // await _userRemote.signOut();

    // clear user info & token
    Storage.token = null;
    deleteToken();
    userProfile = null;

    // get new data
    if (context.mounted) {
      context.read<NewsRepository>().getNewsList();
      context.read<PortalRepository>().getPortalList();
    }

    isLoaded = true;
    isSignedIn = false;
    notifyListeners();
  }
}
