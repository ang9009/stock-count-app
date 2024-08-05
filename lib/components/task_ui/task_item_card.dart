import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/item_details_page.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/get_status_color.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';

class TaskItemCard extends ConsumerWidget {
  final TaskItem taskItem;
  final String docNo;
  final String docType;

  const TaskItemCard({
    super.key,
    required this.taskItem,
    required this.docNo,
    required this.docType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        goToRoute(
          context: context,
          page: ItemDetailsPage(
            itemCode: taskItem.itemCode,
            itemName: taskItem.itemName,
            docNo: docNo,
            docType: docType,
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: WidgetSizes.cardPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskItem.itemName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.heading,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      taskItem.itemCode,
                      style: TextStyles.subHeading,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${taskItem.qtyCollected}/${taskItem.qtyRequired}",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: getStatusColor(
                      taskItem.qtyCollected / taskItem.qtyRequired),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
