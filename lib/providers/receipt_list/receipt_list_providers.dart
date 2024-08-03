import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_receipts.dart';

part 'receipt_list_providers.g.dart';

@riverpod
class SelectedReceipts extends _$SelectedReceipts {
  @override
  Set<ReceiptDownloadOption> build() {
    return {};
  }

  void selectAllReceipts(String currDocType) {
    final allReceipts = ref.read(receiptsProvider(currDocType));

    if (allReceipts.hasValue) {
      state = {...allReceipts.requireValue};
    }
  }

  void addSelectedReceipt(ReceiptDownloadOption receipt) {
    state = {...state, receipt};
  }

  void unselectReceipt(ReceiptDownloadOption receipt) {
    state = {
      for (final currReceipt in state)
        if (currReceipt != receipt) currReceipt
    };
  }

  void clearSelectedReceipts() {
    state = {};
  }
}

@riverpod
class ReceiptsListIsSelecting extends _$ReceiptsListIsSelecting {
  @override
  bool build() {
    return false;
  }

  void setIsSelecting(bool isSelecting) {
    state = isSelecting;
  }
}

@riverpod
class Receipts extends _$Receipts {
  // Make sure docType is fully lowercase to avoid errors
  @override
  Future<List<ReceiptDownloadOption>> build(String docType) async {
    String lowerDocType = docType.trim().toLowerCase();

    return getReceipts(lowerDocType);
  }

  // Used for infinite scroll pagination, fetches next 10 receipts. Offset amount is kept track of
  // in downloads list state variable

  // Returns the list of receipt downloads so that the infinite scroll widget can check if there are
  // no more receipts to fetch
  Future<List<ReceiptDownloadOption>> fetchMoreReceipts(
      String docType, int offset) async {
    // await Future.delayed(Duration(seconds: 3)); // Used this to simulate loading time
    final newReceipts = await getReceiptsWithOffset(docType, offset);
    final currState = await future;

    state = AsyncValue.data([...currState, ...newReceipts]);
    return newReceipts;
  }
}
