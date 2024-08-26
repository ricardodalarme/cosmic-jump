import 'package:cosmic_jump/data/account.dart';
import 'package:cosmic_jump/models/item_model.dart';
import 'package:leap/leap.dart';

mixin HasJetpack on PhysicalEntity {
  bool hasUsedJetpack = false;

  double energy = 0;

  bool get hasJetpack =>
      account.equipments.equippedItems.whereType<JetpackItemModel>().isNotEmpty;
}
