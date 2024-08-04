import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final Function onPressed;

  const FilterButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () => onPressed(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,
      color: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.tertiary,
      ),
      labelPadding: WidgetSizes.actionChipLabelPadding,
      avatar: SvgPicture.asset(
        height: 13.sp,
        iconPath,
        colorFilter: const ColorFilter.mode(
          Colors.black,
          BlendMode.srcIn,
        ),
      ),
      label: Text(label),
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
