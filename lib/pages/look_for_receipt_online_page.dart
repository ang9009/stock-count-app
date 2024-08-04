import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stock_count/components/create_task/receipt_actions.dart';
import 'package:stock_count/components/create_task/receipt_filter_button.dart';
import 'package:stock_count/components/create_task/receipt_list.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';

class LookForReceiptOnlinePage extends ConsumerStatefulWidget {
  const LookForReceiptOnlinePage({super.key});

  @override
  ConsumerState<LookForReceiptOnlinePage> createState() =>
      _LookForReceiptOnlinePageState();
}

class _LookForReceiptOnlinePageState
    extends ConsumerState<LookForReceiptOnlinePage> {
  final PagingController<int, ReceiptDownloadOption> listPagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSelecting = ref.watch(receiptsListIsSelectingProvider);
    final docTypes = ref.watch(docTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Look for receipt online",
          style: TextStyles.largeTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: docTypes.when(
          loading: () => const CircularProgressIndicator(),
          data: (docTypes) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter and select all buttons logic
              if (!isSelecting)
                ReceiptFilterButton(
                  docTypes: docTypes,
                ),
              const SizedBox(width: double.infinity, height: 12),
              Expanded(
                child: ReceiptList(
                  pagingController: listPagingController,
                  docTypes: docTypes,
                ),
              ),
              const ReceiptActions(),
            ],
          ),
          error: (error, stack) => Text(
            error.toString(),
            style: TextStyles.subHeading,
          ),
        ),
      ),
    );
  }
}
