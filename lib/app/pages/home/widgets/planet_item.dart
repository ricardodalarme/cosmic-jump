import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class PlanetItem extends StatelessWidget {
  const PlanetItem({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withOpacity(0.2),
            offset: const Offset(0, -10),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Planets/Pictures/$id.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
