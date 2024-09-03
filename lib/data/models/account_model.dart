import 'package:cosmic_jump/data/resources/planets.dart';

class AccountModel {
  final Set<String> unlockedPlanets;
  final Set<String> unlockedCharacters;
  String currentCharacter;
  int coins;

  AccountModel({
    required this.currentCharacter,
    required this.coins,
    required this.unlockedPlanets,
    required this.unlockedCharacters,
  });

  factory AccountModel.empty() {
    const unlockedCharacter = 'Virtual Guy';

    return AccountModel(
      unlockedCharacters: {unlockedCharacter},
      currentCharacter: unlockedCharacter,
      unlockedPlanets: {planets.first.id},
      coins: 0,
    );
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      currentCharacter: map['currentCharacter'] as String,
      coins: map['coins'] as int,
      unlockedPlanets: (map['unlockedPlanets'] as List<String>).toSet(),
      unlockedCharacters: (map['unlockedCharacters'] as List<String>).toSet(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentCharacter': currentCharacter,
      'coins': coins,
      'unlockedPlanets': unlockedPlanets.toList(),
      'unlockedCharacters': unlockedCharacters.toList(),
    };
  }
}
