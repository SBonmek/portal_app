import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/data/models/token_model.dart';

class Storage {
  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static TokenModel? token;
}
