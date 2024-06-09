import 'package:cosmic_jump/features/fog/fog_model.dart';

final class PlanetModel {
  final String name;
  final String description;
  final double gravity;
  final FogModel? fog;
  final double poison;
  final bool hasMeteorShower;
  final double visibility;

  const PlanetModel({
    required this.name,
    required this.description,
    required this.gravity,
    this.fog,
    this.poison = 0,
    this.hasMeteorShower = false,
    this.visibility = 1,
  });
}
