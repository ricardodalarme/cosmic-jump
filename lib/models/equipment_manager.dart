import 'package:cosmic_jump/models/item_model.dart';

class EquipmentsManager {
  final List<EquipmentItemModel?> _equippedItems =
      List.filled(_maxEquipSlots, null);

  List<EquipmentItemModel?> get equippedItems => _equippedItems;

  static const int _maxEquipSlots = 3;

  void equip(EquipmentItemModel item, int slot) {
    if (slot < 0 || slot >= _maxEquipSlots) {
      throw Exception('Invalid equipment slot');
    }
    _equippedItems[slot] = item;
  }

  void unequip(int slot) {
    if (slot < 0 || slot >= _maxEquipSlots) {
      throw Exception('Invalid equipment slot');
    }
    _equippedItems[slot] = null;
  }
}
