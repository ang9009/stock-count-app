import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/infinite_scroll_list.dart';
import 'package:stock_count/components/scanner_button.dart';
import 'package:stock_count/components/task_item_card.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/scan_bin_page.dart';
import 'package:stock_count/pages/scan_items_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/providers/task_items/task_items_provider.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
import 'package:stock_count/utils/queries/get_task_items.dart';

class TaskPage extends ConsumerWidget {
  final String docNo;
  final String docType;

  const TaskPage({
    super.key,
    required this.docNo,
    required this.docType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskItems = ref.watch(taskItemsProvider(
      docNo: docNo,
      docType: docType,
    ));
    final bin = ref.watch(binNumberProvider);

    return Scaffold(
      floatingActionButton: FloatingIconButton(
        iconPath: "icons/scan.svg",
        onTap: () {
          if (bin == null) {
            goToRoute(context: context, page: const ScanBinPage());
          } else {
            goToRoute(context: context, page: const ScanItemsPage());
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          "Receipt $docNo",
          style: TextStyles.largeTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            InfiniteScrollList(
              pendingListData: taskItems,
              fetchLimit: taskItemsFetchLimit,
              bottomPadding: 33.sp,
              separator: Divider(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              getCurrItemCard: (taskItem) {
                return TaskItemCard(
                  taskItem: taskItem,
                  docNo: docNo,
                  docType: docType,
                );
              },
              getMoreItems: ({required int offset}) {
                final taskItemMethods = ref.read(
                  taskItemsProvider(
                    docNo: docNo,
                    docType: docType,
                  ).notifier,
                );

                return taskItemMethods.getMoreTaskItems(
                  docType: docType,
                  docNo: docNo,
                  offset: offset,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
