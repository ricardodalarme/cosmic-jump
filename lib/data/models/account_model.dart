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
      unlockedPlanets: planets.map((e) => e.id).toSet(),
      coins: 0,
    );
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      currentCharacter: map['currentCharacter'] as String,
      coins: map['coins'] as int,
      unlockedPlanets:
          (map['unlockedPlanets'] as List).map((e) => e as String).toSet(),
      unlockedCharacters:
          (map['unlockedCharacters'] as List).map((e) => e as String).toSet(),
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
