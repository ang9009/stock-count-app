import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class CustomCheckbox extends StatelessWidget {
  final Color? color;
  final Function(bool)? onChanged;
  final bool isChecked;

  const CustomCheckbox({
    super.key,
    this.color,
    this.onChanged,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 18.sp,
        height: 18.sp,
        decoration: BoxDecoration(
          color: isChecked ? Colors.black : Colors.white,
          border: Border.all(
            color: isChecked ? Colors.black : AppColors.lighterTextColor,
          ),
          shape: BoxShape.circle,
        ),
        child: isChecked
            ? Center(
                child: SvgPicture.asset(
                  width: 14.sp,
                  fit: BoxFit.scaleDown,
                  "icons/check.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
