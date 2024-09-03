import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorageService {
  PersistentStorageService._();

  static PersistentStorageService get instance => _instance;
  static final PersistentStorageService _instance =
      PersistentStorageService._();

  late final SharedPreferencesWithCache _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  String? readString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  Future<void> writeString({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  bool? readBool({required String key}) {
    return _sharedPreferences.getBool(key);
  }

  Future<void> writeBool({required String key, required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  Future<void> delete({required String key}) async {
    await _sharedPreferences.remove(key);
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
