import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/create_task/receipt_card.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_receipts.dart';

class ReceiptList extends ConsumerStatefulWidget {
  final List<ReceiptDocTypeFilterOption> docTypes;
  final PagingController<int, ReceiptDownloadOption> pagingController;

  const ReceiptList({
    required this.pagingController,
    required this.docTypes,
    super.key,
  });

  @override
  ConsumerState<ReceiptList> createState() => ReceiptListState();
}

class ReceiptListState extends ConsumerState<ReceiptList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
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
        widget.pagingController.appendLastPage(newReceipts);
      } else {
        int newPageKey = pageKey + receiptsFetchLimit;
        widget.pagingController.appendPage(newReceipts, newPageKey);
      }
    } catch (error) {
      widget.pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currType = ref.read(selectedReceiptTypeProvider);
    ref.listen(selectedReceiptTypeProvider, (previous, next) {
      widget.pagingController.refresh();
    });

    return PagedListView.separated(
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ReceiptDownloadOption>(
        itemBuilder: (context, item, index) => ReceiptCard(
          receipt: item,
          parentType: currType!.parentType,
        ),
        firstPageProgressIndicatorBuilder: (context) =>
            const ReceiptListLoadingAnimation(),
        newPageProgressIndicatorBuilder: (context) =>
            const ReceiptListLoadingAnimation(),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 12.sp),
    );
  }

  @override
  void dispose() {
    widget.pagingController.dispose();
    super.dispose();
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
