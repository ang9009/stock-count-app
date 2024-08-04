import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class AddTaskOption extends StatelessWidget {
  final String label;
  final Function onTap;
  final String icon;

  const AddTaskOption({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.sp,
            vertical: 17.sp,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.borderColor,
                radius: 18.sp,
                child: SvgPicture.asset(
                  height: 18.sp,
                  icon,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(
                width: 15.sp,
              ),
              Text(
                label,
                style: TextStyles.heading,
              ),
              const Spacer(),
              SvgPicture.asset(
                height: 13.sp,
                "icons/chevron_right.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
