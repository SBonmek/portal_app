import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/utils/secure_token_storage.dart';
import 'package:portal_app/core/utils/show_error_snack_bar.dart';
import 'package:portal_app/features/data/models/user_model.dart';
import 'package:portal_app/features/data/repositories/news_banner_repository.dart';
import 'package:portal_app/features/data/repositories/portal_repository.dart';
import 'package:provider/provider.dart';

// default data
UserModel _mockUser = UserModel(displayName: "Mock Name", photoUrl: null);

class AuthRepository extends ChangeNotifier {
  // temp data
  bool isLoaded = false;
  bool isSignedIn = false;
  UserModel? userInfoes;

  // auth data
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final String _clientId = 'flutter';
  final String _redirectUrl = 'com.example.portalapp:/oauth2redirect';
  final String _issuer = 'https://sso.pupasoft.com/realms/master';
  final String _discoveryUrl =
      'https://sso.pupasoft.com/realms/master/.well-known/openid-configuration';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
  ];

  Future<void> checkToken(BuildContext context) async {
    isSignedIn = await _isSignedIn();

    if (isSignedIn) {
      //TODO request get info

      // save user info
      Storage.token = await getToken();
      userInfoes = _mockUser;

      if (context.mounted) {
        context.read<NewsBannerRepository>().getNewsBannerList();
        context.read<PortalRepository>().getPortalList();
      }
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<void> signInWithKeyCloak(BuildContext context) async {
    try {
      isLoaded = false;
      isSignedIn = false;
      notifyListeners();

      final AuthorizationResponse? response = await _appAuth.authorize(
        AuthorizationRequest(
          _clientId,
          _redirectUrl,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes,
        ),
      );

      if (response != null) {
        final TokenResponse? tokenResponse = await _appAuth.token(
          TokenRequest(
            _clientId,
            _redirectUrl,
            discoveryUrl: _discoveryUrl,
            codeVerifier: response.codeVerifier,
            nonce: response.nonce,
            authorizationCode: response.authorizationCode,
          ),
        );

        if (tokenResponse != null) {
          // save token
          Storage.token = {
            "idToken": tokenResponse.idToken,
            "accessToken": tokenResponse.accessToken,
            "refreshToken": tokenResponse.refreshToken,
          };
          await saveToken(Storage.token);

          //TODO request get info

          // save user info
          userInfoes = _mockUser;

          // get new data
          if (context.mounted) {
            context.read<NewsBannerRepository>().getNewsBannerList();
            context.read<PortalRepository>().getPortalList();
          }
        }
      } else {
        if (context.mounted) {
          showErrorSnackBar(
            context,
            errorText: "Authorization error",
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          errorText: error.toString(),
        );
      }
    }

    isLoaded = true;
    isSignedIn = true;
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

  signOut(BuildContext context) async {
    isLoaded = false;
    notifyListeners();

    //TODO request sign out

    // clear user info & token
    Storage.token.clear();
    deleteToken();
    userInfoes = null;

    // get new data
    if (context.mounted) {
      context.read<NewsBannerRepository>().getNewsBannerList();
      context.read<PortalRepository>().getPortalList();
    }

    isLoaded = true;
    isSignedIn = false;
    notifyListeners();
  }
}
