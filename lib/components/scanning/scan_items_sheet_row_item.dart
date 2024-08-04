import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class ScanItemsSheetRowItem extends StatelessWidget {
  final String label;
  final String value;

  const ScanItemsSheetRowItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.lighterTextColor,
            fontSize: 17.sp,
          ),
        ),
        SizedBox(width: 30.sp),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: const Color.fromARGB(255, 90, 76, 76),
              fontSize: 17.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
