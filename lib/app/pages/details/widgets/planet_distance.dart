import 'dart:math' as math;

import 'package:cosmic_jump/app/widgets/fade_in_animation.dart';
import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:cosmic_jump/data/models/planet_model.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanetDistance extends StatelessWidget {
  const PlanetDistance({
    required this.planet,
    super.key,
  });

  final PlanetModel planet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Distância da Terra',
          style: TextStyle(
            letterSpacing: 1.2,
            color: AppColors.lightBlue,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${planet.distancefromEarth.toStringAsFixed(0)} km',
          style: const TextStyle(
            letterSpacing: 1.2,
            color: AppColors.lightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const _PlanetDistanceIndicator(),
      ],
    );
  }
}

class _PlanetDistanceIndicator extends StatelessWidget {
  const _PlanetDistanceIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/earth.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.lightBlue,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const DottedLine(
                  dashColor: AppColors.lightBlue,
                  dashLength: 10,
                  lineThickness: 2,
                ),
                FadeInAnimation(
                  position: const MyAnimation(
                    leftAfter: 300,
                    leftBefore: 0,
                  ),
                  delayInMs: 750,
                  durationInMs: 1000,
                  child: Transform.rotate(
                    angle: 45 * math.pi / 180,
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
