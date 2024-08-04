import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/create_task/receipt_actions.dart';
import 'package:stock_count/components/create_task/receipt_card.dart';
import 'package:stock_count/components/create_task/receipt_filter_button.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
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
    ref.listen(selectedReceiptTypeProvider, (previous, next) {
      listPagingController.refresh();
    });
    final currType = ref.watch(selectedReceiptTypeProvider);

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
                child: InfiniteScrollList(
                  pagingController: listPagingController,
                  fetchPage: _fetchPage,
                  itemBuilder: (ReceiptDownloadOption item) {
                    return ReceiptCard(
                      receipt: item,
                      parentType: currType!.parentType,
                    );
                  },
                  loadingAnimation: const ReceiptListLoadingAnimation(),
                  separatorBuilder: () => SizedBox(height: 12.sp),
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

  Future<void> _fetchPage(int pageKey) async {
    final currType = ref.read(selectedReceiptTypeProvider);
    if (currType == null) return;

    try {
      final newReceipts = await getReceipts(
        docType: currType.parentType,
        offset: pageKey,
      );

      final isLastPage = newReceipts.length < receiptsFetchLimit;
      if (isLastPage) {
        listPagingController.appendLastPage(newReceipts);
      } else {
        int newPageKey = pageKey + receiptsFetchLimit;
        listPagingController.appendPage(newReceipts, newPageKey);
      }
    } catch (error) {
      listPagingController.error = error;
    }
  }
}

class ReceiptListLoadingAnimation extends StatelessWidget {
  const ReceiptListLoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          Skeletonizer(
            child: ReceiptCard(
              parentType: "XD",
              receipt: ReceiptDownloadOption(
                creationDate: DateTime.now(),
                docNo: "ASDASDASD",
                docType: "ASDASDASD",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
