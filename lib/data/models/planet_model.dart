import 'package:cosmic_jump/data/models/fog_model.dart';

class PlanetModel {
  const PlanetModel({
    required this.id,
    required this.size,
    required this.distancefromEarth,
    required this.name,
    required this.title,
    required this.temperature,
    required this.satellites,
    required this.orbitalSpeed,
    required this.surfaceArea,
    required this.rotationPeriod,
    required this.gravity,
    this.isPlayable = true,
    this.fog,
    this.poison = 0,
    this.hasMeteorShower = false,
    this.visibility = 1,
  });

  final String id;
  final String name;
  final String title;
  final double size;
  final double distancefromEarth;
  final int temperature;
  final int satellites;
  final double orbitalSpeed;
  final double surfaceArea;
  final double rotationPeriod;
  final bool isPlayable;
  final double gravity;
  final FogModel? fog;
  final int poison;
  final bool hasMeteorShower;
  final double visibility;
}
