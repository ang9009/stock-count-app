import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class BottomDrawer extends StatefulWidget {
  final String title;
  final Widget contents;
  final EdgeInsets? padding;

  const BottomDrawer({
    super.key,
    required this.title,
    required this.contents,
    this.padding,
  });

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.sp),
          // Drag handle
          Container(
            width: 45,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 / 2),
              color: AppColors.borderColor,
            ),
          ),
          SizedBox(height: 15.sp),
          Text(
            widget.title,
            style: TextStyles.largeTitle,
          ),
          SizedBox(height: 15.sp),
          const Divider(
            height: 0,
            indent: 0,
            thickness: 1,
            color: AppColors.borderColor,
          ),
          Padding(
            padding: widget.padding ?? EdgeInsets.all(20.sp),
            child: widget.contents,
          ),
          // To ensure that the bottom sheet stays above the keyboard
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
          ),
        ],
      ),
    );
  }
}
