import 'package:cosmic_jump/features/fog/fog_model.dart';
import 'package:cosmic_jump/features/planet/planet_model.dart';
import 'package:flutter/painting.dart';

const List<PlanetModel> planets = [
  PlanetModel(
    name: 'mercury',
    description:
        'The smallest planet in the Solar System and the closest to the Sun.',
    gravity: 3.7,
    hasMeteorShower: true,
  ),
  PlanetModel(
    name: 'venus',
    description:
        'The second planet from the Sun. It is named after the Roman goddess of love and beauty.',
    gravity: 8.87,
    fog: FogModel(
      speed: 10,
      density: 0.1,
      color: Color(0xFFD4A185),
    ),
    poison: 1,
  ),
  PlanetModel(
    name: 'mars',
    description:
        'The fourth planet from the Sun and the second-smallest planet in the Solar System, being larger than only Mercury.',
    gravity: 3.71,
  ),
];
