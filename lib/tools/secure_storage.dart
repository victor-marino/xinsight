import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future<String?> read(String key) async {
    final value = await _storage.read(key: key);
    return(value);
  }

  Future<Map<String, String>> readAll() async {
    final all = await _storage.readAll();
    return (all);
  }

  Future<void> storeKey(
      {required String keyName, required String value}) async {
    await _storage.write(key: keyName, value: value);
    readAll();
  }

  Future<void> deleteKey(
      {required String keyName}) async {
    await _storage.delete(key: keyName);
    readAll();
  }

  void deleteAll() async {
    await _storage.deleteAll();
    readAll();
  }
}
