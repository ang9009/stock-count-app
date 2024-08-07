import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

enum RoundedButtonStyles {
  solid,
  outlined,
}

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final bool? isDisabled;
  final String label;
  final RoundedButtonStyles style;

  const RoundedButton({
    required this.style,
    super.key,
    required this.onPressed,
    required this.label,
    this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final outlinedStyle = ElevatedButton.styleFrom(
      side: const BorderSide(
        color: AppColors.borderColor,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      padding: EdgeInsets.symmetric(
        horizontal: 12.sp,
        vertical: 15.sp,
      ),
    );

    final solidStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      elevation: 0,
      padding: EdgeInsets.symmetric(
        horizontal: 12.sp,
        vertical: 15.sp,
      ),
    );

    return ElevatedButton(
      style: style == RoundedButtonStyles.solid ? solidStyle : outlinedStyle,
      onPressed: isDisabled ?? false ? null : () => onPressed(),
      child: Text(
        label,
        style: TextStyle(
          color:
              style == RoundedButtonStyles.solid ? Colors.white : Colors.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
