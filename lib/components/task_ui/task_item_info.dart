import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/utils/object_classes.dart';

class TaskItemInfo extends ConsumerStatefulWidget {
  final TaskItem taskItem;
  final String docNo;
  final String docType;
  final List<ItemVariant>? itemList;

  const TaskItemInfo({
    super.key,
    required this.taskItem,
    required this.docNo,
    required this.docType,
    required this.itemList,
  });

  @override
  ConsumerState<TaskItemInfo> createState() => _TaskItemInfoState();
}

class _TaskItemInfoState extends ConsumerState<TaskItemInfo> {
  final subHeadingStyle = TextStyle(
    fontSize: TextStyles.heading.fontSize,
    color: AppColors.lighterTextColor,
  );
  final infoStyle = TextStyle(
    fontSize: TextStyles.heading.fontSize,
    color: Colors.black,
    overflow: TextOverflow.clip,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String qtyCollected;
    if (widget.itemList == null) {
      qtyCollected = "NaN";
    } else {
      int totalQty = 0;
      for (final item in widget.itemList!) {
        totalQty += item.qtyCollected;
      }
      qtyCollected = totalQty.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Item name",
                style: subHeadingStyle,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                widget.taskItem.itemName ?? "Unknown",
                style: infoStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Item code",
                style: subHeadingStyle,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                widget.taskItem.itemCode,
                style: infoStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Quantity collected",
                style: subHeadingStyle,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                "$qtyCollected/${widget.taskItem.qtyRequired}",
                style: infoStyle,
              ),
            ),
          ],
        )
      ],
    );
  }
}
