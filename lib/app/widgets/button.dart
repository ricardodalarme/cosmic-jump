import 'package:cosmic_jump/constants/colors.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  const Button({
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isDense = false,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isEnabled ? darkBlue : disabled;
    final textColor = isEnabled ? white : disabled2;

    return GestureDetector(
      onTap: isEnabled ? onPressed : () => {},
      child: Container(
        padding: isDense
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? const [
                  BoxShadow(
                    color: lightBlue2,
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
