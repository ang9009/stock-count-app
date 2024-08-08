import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/item_details_page.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/get_status_color.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
import 'package:stock_count/utils/object_classes.dart';

class TaskItemCard extends ConsumerWidget {
  final TaskItem taskItem;
  final String docNo;
  final String docType;
  final PagingController<int, TaskItem> taskItemsListController;

  const TaskItemCard({
    super.key,
    required this.taskItem,
    required this.docNo,
    required this.docType,
    required this.taskItemsListController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        goToPageWithAnimation(
          context: context,
          page: ItemDetailsPage(
            taskItem: taskItem,
            docNo: docNo,
            docType: docType,
            taskItemsListController: taskItemsListController,
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
                      taskItem.itemName == unknownItemName
                          ? "Unknown item name"
                          : taskItem.itemName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.heading,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      taskItem.itemCode ?? "Item code N/A",
                      style: TextStyles.subHeading,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                taskItem.qtyRequired == 0
                    ? "${taskItem.qtyCollected}"
                    : "${taskItem.qtyCollected}/${taskItem.qtyRequired}",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: taskItem.qtyRequired == null
                      ? Colors.black
                      : getStatusColor(
                          taskItem.qtyCollected / taskItem.qtyRequired!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
