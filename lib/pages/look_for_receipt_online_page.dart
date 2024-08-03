import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/api/services/web_service.dart';
import 'package:stock_count/components/infinite_scroll_list.dart';
import 'package:stock_count/components/receipt_actions.dart';
import 'package:stock_count/components/receipt_card.dart';
import 'package:stock_count/components/receipt_filter_button.dart';
import 'package:stock_count/components/receipt_filter_modal.dart';
import 'package:stock_count/components/receipt_selection_options.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_receipts.dart';

class LookForReceiptOnlinePage extends ConsumerStatefulWidget {
  const LookForReceiptOnlinePage({super.key});

  @override
  ConsumerState<LookForReceiptOnlinePage> createState() =>
      _LookForReceiptOnlinePageState();
}

class _LookForReceiptOnlinePageState
    extends ConsumerState<LookForReceiptOnlinePage> {
  late ({String docDesc, String parentType}) selectedFilterOption;
  late ({String docDesc, String parentType}) selectedModalFilterOption;
  late Future<ApiResponse> documentTypes;
  late Future<List<dynamic>> receipts;

  Future<ApiResponse> getDocTypes() async {
    final res = await ApiService.executeSQLQuery(
      null,
      [
        ApiService.sqlQueryParm(
          "SELECT DISTINCT doc_desc, parent_type FROM stock_count_control WHERE need_ref_no = 'Y'",
        ),
      ],
    );

    if (!res.isError) {
      final resData = ApiService.sqlQueryResult(res);

      if (resData.isNotEmpty) {
        // Make sure parent type is always lowercase. It's passed into many child widgets
        // and used for function calls, so discrepancies when it comes to capitalization
        // will lead to errors
        String docDesc = resData[0]["doc_desc"];
        String parentType = resData[0]["parent_type"].toString().toLowerCase();
        final ({String docDesc, String parentType}) optionData =
            (docDesc: docDesc, parentType: parentType);

        setState(() {
          selectedFilterOption = optionData;
          selectedModalFilterOption = optionData;
        });
      }
    }

    return res;
  }

  Future<List<ReceiptDownloadOption>> getMoreReceipts(int offset) {
    final receiptsMethods =
        ref.read(receiptsProvider(selectedFilterOption.parentType).notifier);

    return receiptsMethods.fetchMoreReceipts(
      selectedFilterOption.parentType,
      offset,
    );
  }

  Widget getCurrReceiptCard(ReceiptDownloadOption receipt) {
    return ReceiptCard(
      receipt: receipt,
      parentType: selectedFilterOption.parentType,
    );
  }

  @override
  void initState() {
    super.initState();
    documentTypes = getDocTypes();
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
      bottomNavigationBar: isSelecting
          ? ReceiptActions(
              parentType: selectedFilterOption.parentType,
            )
          : const SizedBox.shrink(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder(
          future: documentTypes,
          builder: (context, snapshot) {
            List<Widget> children;

            if (snapshot.hasData) {
              List<dynamic> documentTypesList =
                  ApiService.sqlQueryResult(snapshot.data!);
              final receipts =
                  ref.watch(receiptsProvider(selectedFilterOption.parentType));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter and select all buttons logic
                  Container(child: () {
                    if (!isSelecting) {
                      return ReceiptFilterButton(
                        documentTypes: documentTypesList,
                        selectedFilterOption: selectedFilterOption.docDesc,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, modalSetState) {
                                  return ReceiptFilterModal(
                                    selectedModalFilterOption:
                                        selectedModalFilterOption,
                                    documentTypes: documentTypesList,
                                    onOptionSelected: (selectedOption) {
                                      modalSetState(() {
                                        selectedModalFilterOption =
                                            selectedOption;
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ).whenComplete(() {
                            // Only update selected filter option when bottom sheet is closed
                            setState(() {
                              selectedFilterOption = selectedModalFilterOption;
                            });
                            ref
                                .read(selectedReceiptsProvider.notifier)
                                .clearSelectedReceipts();
                          });
                        },
                      );
                    } else {
                      return ReceiptSelectionOptions(
                        currDocType: selectedFilterOption.parentType,
                      );
                    }
                  }()),
                  // Receipt download list
                  const SizedBox(width: double.infinity, height: 12),
                  InfiniteScrollList(
                    pendingListData: receipts,
                    fetchLimit: receiptsFetchLimit,
                    getMoreItems: ({required int offset}) {
                      return getMoreReceipts(offset);
                    },
                    getCurrItemCard: (receipt) {
                      return getCurrReceiptCard(receipt);
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              children = [
                Text(
                  "An error occurred: ${snapshot.error.toString()}",
                  style: TextStyles.subHeading,
                ),
              ];
            } else {
              children = [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ];
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
