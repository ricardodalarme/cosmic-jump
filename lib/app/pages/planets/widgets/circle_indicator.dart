import 'package:circle_list/circle_list.dart';
import 'package:cosmic_jump/app/theme/colors.dart';
import 'package:flutter/widgets.dart';

class CircleIndicator extends StatelessWidget {
  const CircleIndicator({
    required this.currentIndex,
    required this.length,
    super.key,
  });

  final int currentIndex;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -390,
      child: CircleList(
        outerRadius: 418,
        innerRadius: 400,
        initialAngle: -1.55 - (currentIndex * 0.15),
        children: List.generate(
          length * 5,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  currentIndex == index ? white.withOpacity(0.3) : transparent,
            ),
            child: AnimatedContainer(
              width: 10,
              height: 10,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index ? white : white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
