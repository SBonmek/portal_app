import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static Map<String, dynamic> token = {};
}
