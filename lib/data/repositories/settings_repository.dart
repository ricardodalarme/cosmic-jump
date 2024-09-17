import 'dart:convert';

import 'package:cosmic_jump/data/models/settings_model.dart';
import 'package:cosmic_jump/services/storage_service.dart';

class SettingsRepository {
  SettingsRepository._();

  static SettingsRepository get instance => _instance;
  static final SettingsRepository _instance = SettingsRepository._();

  static const String _storageKey = 'settings';

  SettingsModel get() {
    final data = StorageService.instance.readString(_storageKey);

    if (data == null) {
      return SettingsModel.empty();
    }

    final dataToMap = jsonDecode(data) as Map<String, dynamic>;
    return SettingsModel.fromMap(dataToMap);
  }

  Future<void> save(SettingsModel settings) async {
    final data = jsonEncode(settings.toMap());
    await StorageService.instance.writeString(_storageKey, value: data);
  }
}
