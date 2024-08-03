import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class ReceiptFilterButton extends StatelessWidget {
  final List<dynamic> documentTypes;
  // Called when filter options menu is closed
  final Function() onPressed;
  final String selectedFilterOption;
  const ReceiptFilterButton({
    super.key,
    required this.documentTypes,
    required this.selectedFilterOption,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.only(
        right: 10,
      ),
      avatar: SvgPicture.asset(
        height: 13.sp,
        "icons/filter.svg",
        colorFilter: const ColorFilter.mode(
          Colors.black,
          BlendMode.srcIn,
        ),
      ),
      label: Text("Filter by: \"$selectedFilterOption\""),
      backgroundColor: AppColors.borderColor,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      side: const BorderSide(
        color: Colors.transparent,
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
