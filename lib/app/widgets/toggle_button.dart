import 'package:cosmic_jump/constants/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AnimatedToggle extends StatelessWidget {
  final List<String> values;
  final ValueChanged<int?> onChanged;
  final int currentIndex;

  const AnimatedToggle({
    required this.values,
    required this.onChanged,
    this.currentIndex = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: currentIndex,
      totalSwitches: values.length,
      cornerRadius: 16,
      labels: values,
      minWidth: 120,
      onToggle: onChanged,
      activeFgColor: white,
      activeBgColor: const [lightBlue2],
      animate: true,
      animationDuration: 150,
      customTextStyles: const [
        TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
        ),
        TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
