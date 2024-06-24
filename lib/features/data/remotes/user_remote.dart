import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/errors/exceptions.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';
import 'package:portal_app/core/utils/secure_token_storage.dart';
import 'package:portal_app/features/data/models/token_model.dart';
import 'package:portal_app/features/data/models/user_profile_model.dart';

abstract class UserRemote {
  Future<TokenResponse> signInWithKeyCloak();
  Future<TokenResponse> refreshingToken();
  Future<void> signOut();
  Future<UserProfileModel> getProfile();
}

class UserRemoteImpl implements UserRemote {
  final HttpRequestWrapper _httpRequestWrapper = HttpRequestWrapperImpl();
  final String api = "profile";

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

  @override
  Future<TokenResponse> signInWithKeyCloak() async {
    try {
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
          return tokenResponse;
        } else {
          throw Exception("Exchanging  Token error");
        }
      } else {
        throw Exception("Authorization error");
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<TokenResponse> refreshingToken() async {
    try {
      TokenModel? token = await getToken();
      if (token != null) {
        final TokenResponse? tokenResponse = await _appAuth.token(
          TokenRequest(
            _clientId,
            _redirectUrl,
            discoveryUrl: _discoveryUrl,
            refreshToken: token.refreshToken,
            scopes: _scopes,
          ),
        );

        if (tokenResponse != null) {
          return tokenResponse;
        }
      }
      throw Exception("Exchanging  Token error");
    } catch (_) {
      print(_);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: Storage.token!.idToken,
          postLogoutRedirectUrl: 'com.example.portalapp:/',
        ),
      );
    } catch (_) {
      print(_);
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final results =
          await _httpRequestWrapper.listPagedRestful(pagedRestful: api);

      return UserProfileModel.fromJson(results);
    } on ServerException catch (_) {
      rethrow;
    } catch (error) {
      throw ServerException(message: "GetProfile | ${error.toString()}");
    }
  }
}
