import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:portal_app/core/config/storage.dart';
import 'package:portal_app/core/utils/parse_jwt.dart';

/// delete from keystore/keychain
Future<void> deleteToken() async {
  await Storage.secureStorage.delete(
    key: 'auth_token',
    aOptions: _getAndroidOptions(),
  );
}

/// write to keystore/keychain
Future<void> saveToken(dynamic token) async {
  String encodeToken = json.encode(token);
  await Storage.secureStorage.write(
    key: 'auth_token',
    value: encodeToken,
    aOptions: _getAndroidOptions(),
  );
}

/// read to keystore/keychain
Future<dynamic> getToken() async {
  final encodeToken = await Storage.secureStorage.read(
        key: 'auth_token',
        aOptions: _getAndroidOptions(),
      ) ??
      "";

  if (encodeToken.isNotEmpty) {
    return json.decode(encodeToken);
  } else {
    return null;
  }
}

Future getExpireTokenDateTime() async {
  final token = await getToken();
  final decodeUserToken = parseJwt(token["access_token"]);
  return DateTime.fromMillisecondsSinceEpoch(
    decodeUserToken["exp"] * 1000,
  );
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
