import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/scanning/scanner_button.dart';
import 'package:stock_count/components/task_ui/task_card.dart';
import 'package:stock_count/components/task_ui/task_item_card.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/scan_bin_page.dart';
import 'package:stock_count/pages/scan_items_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/queries/get_task_items.dart';

class TaskPage extends ConsumerStatefulWidget {
  final String docNo;
  final String docType;

  const TaskPage({
    super.key,
    required this.docNo,
    required this.docType,
  });

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  final PagingController<int, TaskItem> taskItemsListController =
      PagingController(firstPageKey: 0);

  @override
  Widget build(BuildContext context) {
    final bin = ref.watch(binNumberProvider);

    return Scaffold(
      floatingActionButton: FloatingIconButton(
        iconPath: "assets/icons/scan.svg",
        onTap: () {
          if (bin == null) {
            goToPageWithAnimation(
              context: context,
              page: ScanBinPage(
                taskItemsListController: taskItemsListController,
              ),
            );
          } else {
            goToPageWithAnimation(
              context: context,
              page: ScanItemsPage(
                taskItemsListController: taskItemsListController,
              ),
            );
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          "Receipt ${widget.docNo}",
          style: TextStyles.largeTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: InfiniteScrollList<TaskItem>(
          pagingController: taskItemsListController,
          itemBuilder: (item) => TaskItemCard(
            taskItem: item,
            docNo: widget.docNo,
            docType: widget.docType,
            taskItemsListController: taskItemsListController,
          ),
          loadingAnimation: const TaskItemListLoadingAnimation(),
          getItems: (page) async {
            return await getTaskItems(
              widget.docType,
              widget.docNo,
              page,
            );
          },
          separatorBuilder: const Divider(
            color: AppColors.borderColor,
          ),
          fetchLimit: taskItemsFetchLimit,
        ),
      ),
    );
  }
}

class TaskItemListLoadingAnimation extends StatelessWidget {
  const TaskItemListLoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Skeletonizer(
            child: TaskCard(
              task: Task(
                parentType: "DN",
                docNo: "123ABC345",
                docType: "DN",
                createdAt: DateTime.now(),
                qtyRequired: 69,
                qtyCollected: 23,
                lastUpdated: DateTime.now(),
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: TaskCard(
              task: Task(
                parentType: "DN",
                docNo: "123ABC345",
                docType: "DN",
                createdAt: DateTime.now(),
                qtyRequired: 69,
                qtyCollected: 23,
                lastUpdated: DateTime.now(),
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: TaskCard(
              task: Task(
                parentType: "DN",
                docNo: "123ABC345",
                docType: "DN",
                createdAt: DateTime.now(),
                qtyRequired: 69,
                qtyCollected: 23,
                lastUpdated: DateTime.now(),
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: TaskCard(
              task: Task(
                parentType: "DN",
                docNo: "123ABC345",
                docType: "DN",
                createdAt: DateTime.now(),
                qtyRequired: 69,
                qtyCollected: 23,
                lastUpdated: DateTime.now(),
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: TaskCard(
              task: Task(
                parentType: "DN",
                docNo: "123ABC345",
                docType: "DN",
                createdAt: DateTime.now(),
                qtyRequired: 69,
                qtyCollected: 23,
                lastUpdated: DateTime.now(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
