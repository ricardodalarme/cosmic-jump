import 'package:cosmic_jump/data/planets.dart';

class AccountModel {
  final Set<String> unlockedPlanets = {planets.first.id};
  int coins = 0;
}
