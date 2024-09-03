import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DescriptionTile extends StatelessWidget {
  const DescriptionTile({
    required this.svg,
    required this.text,
    required this.value,
    required this.unit,
    super.key,
  });

  final String svg;
  final String text;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBlue2,
        borderRadius: BorderRadius.circular(42),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            svg,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$value $unit',
                style: const TextStyle(
                  color: AppColors.white,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
