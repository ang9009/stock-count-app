import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/scanning/scanner_button.dart';
import 'package:stock_count/components/task_ui/task_card.dart';
import 'package:stock_count/components/task_ui/task_card.dart';
import 'package:stock_count/components/task_ui/task_item_card.dart';
import 'package:stock_count/components/task_ui/task_item_card.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/scan_bin_page.dart';
import 'package:stock_count/pages/scan_items_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
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
          "Receipt ${widget.docNo}",
          style: TextStyles.largeTitle,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
