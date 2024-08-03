import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stock_count/components/receipt_actions.dart';
import 'package:stock_count/components/receipt_card.dart';
import 'package:stock_count/components/receipt_filter_button.dart';
import 'package:stock_count/components/receipt_list.dart';
import 'package:stock_count/components/receipt_selection_options.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/get_doc_type_options.dart';

class LookForReceiptOnlinePage extends ConsumerStatefulWidget {
  const LookForReceiptOnlinePage({super.key});

  @override
  ConsumerState<LookForReceiptOnlinePage> createState() =>
      _LookForReceiptOnlinePageState();
}

class _LookForReceiptOnlinePageState
    extends ConsumerState<LookForReceiptOnlinePage> {
  late Future<List<ReceiptDocTypeFilterOption>> pendingDocTypes;
  final PagingController<int, ReceiptDownloadOption> listPagingController =
      PagingController(firstPageKey: 0);

  Widget getCurrReceiptCard(
    ReceiptDownloadOption receipt,
    ReceiptDocTypeFilterOption selectedType,
  ) {
    return ReceiptCard(
      receipt: receipt,
      parentType: selectedType.parentType,
    );
  }

  @override
  void initState() {
    pendingDocTypes = getDocTypeOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSelecting = ref.watch(receiptsListIsSelectingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Look for receipt online",
          style: TextStyles.largeTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder(
          future: pendingDocTypes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final docTypes = snapshot.data!;
              final currDocType =
                  ref.read(selectedReceiptTypeProvider(docTypes));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter and select all buttons logic
                  Container(child: () {
                    if (!isSelecting) {
                      return ReceiptFilterButton(
                        docTypes: docTypes,
                      );
                    } else {
                      return ReceiptSelectionOptions(
                        allReceipts: listPagingController.itemList,
                        currDocType: currDocType.parentType,
                      );
                    }
                  }()),
                  const SizedBox(width: double.infinity, height: 12),
                  Expanded(
                    child: ReceiptList(
                      pagingController: listPagingController,
                      docTypes: docTypes,
                    ),
                  ),
                  ReceiptActions(
                    selectedReceiptType: currDocType,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
                style: TextStyles.subHeading,
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
