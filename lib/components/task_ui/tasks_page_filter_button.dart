import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/scanning/bottom_drawer.dart';
import 'package:stock_count/components/ui/filter_button.dart';
import 'package:stock_count/data/primary_theme.dart';

class TasksPageFilterButton extends StatefulWidget {
  const TasksPageFilterButton({super.key});

  @override
  State<TasksPageFilterButton> createState() => _TasksPageFilterButtonState();
}

class _TasksPageFilterButtonState extends State<TasksPageFilterButton> {
  @override
  Widget build(BuildContext context) {
    return FilterButton(
      label: "Filters",
      iconPath: "icons/filter.svg",
      onPressed: () {
        showModal(context);
      },
    );
  }
}

void showModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomDrawer(
        title: "Select filter type",
        contents: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date created/modified",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.sp,
                  ),
                ),
                SvgPicture.asset(
                  height: 14.sp,
                  "icons/chevron_right.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.borderColor,
              height: 24.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Document type",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.sp,
                  ),
                ),
                SvgPicture.asset(
                  height: 14.sp,
                  "icons/chevron_right.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
