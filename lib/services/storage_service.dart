import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static StorageService get instance => _instance;
  static final StorageService _instance = StorageService._();

  late final SharedPreferencesWithCache _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  String? readString(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<void> writeString(String key, {required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  bool? readBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  Future<void> writeBool(String key, {required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  Future<void> delete(String key) async {
    await _sharedPreferences.remove(key);
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
