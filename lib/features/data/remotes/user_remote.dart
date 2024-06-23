import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:portal_app/core/errors/exceptions.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';
import 'package:portal_app/features/data/models/user_profile_model.dart';

abstract class UserRemote {
  Future<TokenResponse> signInWithKeyCloak();
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
