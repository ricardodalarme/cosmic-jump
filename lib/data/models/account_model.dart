import 'package:cosmic_jump/data/resources/planets.dart';

class AccountModel {
  final Set<String> unlockedPlanets = {planets.first.id};
  final Set<String> unlockedCharacters = {'Virtual Guy'};

  String currentCharacter = '';

  int coins = 50;

  AccountModel() {
    currentCharacter = unlockedCharacters.first;
  }
}
