import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/custom_checkbox.dart';

class LabelledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function() onTap;

  const LabelledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 15.sp),
          CustomCheckbox(
            isChecked: value,
          ),
        ],
      ),
    );
  }
}
