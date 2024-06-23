import 'package:cosmic_jump/features/fog/fog_model.dart';
import 'package:cosmic_jump/features/planet/planet_model.dart';
import 'package:flutter/painting.dart';

const List<PlanetModel> planets = [
  PlanetModel(
    name: 'Mercury',
    gravity: 3.7,
    hasMeteorShower: true,
  ),
  PlanetModel(
    name: 'Venus',
    gravity: 8.87,
    fog: FogModel(
      speed: 10,
      density: 0.1,
      color: Color(0xFFD4A185),
    ),
    poison: 1,
  ),
  PlanetModel(
    name: 'Mars',
    gravity: 3.71,
    visibility: 0.2,
  ),
];
