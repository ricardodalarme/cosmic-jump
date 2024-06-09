import 'package:flutter/painting.dart';

final class FogModel {
  final double density;
  final double speed;
  final Color color;

  const FogModel({
    required this.density,
    required this.speed,
    required this.color,
  });
}
