import 'package:cosmic_jump/features/item/item.dart';

class EquipmentsManager {
  final List<EquipmentItem?> _equippedItems = List.filled(_maxEquipSlots, null);

  List<EquipmentItem?> get equippedItems => _equippedItems;

  static const int _maxEquipSlots = 3;

  void equip(EquipmentItem item, int slot) {
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
