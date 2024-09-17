import 'dart:convert';

import 'package:cosmic_jump/data/models/account_model.dart';
import 'package:cosmic_jump/services/storage_service.dart';

class AccountRepository {
  AccountRepository._();

  static AccountRepository get instance => _instance;
  static final AccountRepository _instance = AccountRepository._();

  static const String _storageKey = 'account';

  AccountModel get() {
    final data = StorageService.instance.readString(_storageKey);

    if (data == null) {
      return AccountModel.empty();
    }

    final dataToMap = jsonDecode(data) as Map<String, dynamic>;
    return AccountModel.fromMap(dataToMap);
  }

  Future<void> save(AccountModel account) async {
    final data = jsonEncode(account.toMap());
    await StorageService.instance.writeString(_storageKey, value: data);
  }
}
