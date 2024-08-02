import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_receipts.dart';

part 'receipt_list_providers.g.dart';

@riverpod
class SelectedReceiptType extends _$SelectedReceiptType {
  @override
  ReceiptDocTypeFilterOption build(
    List<ReceiptDocTypeFilterOption> typeOptions,
  ) {
    return typeOptions[0];
  }

  void setSelectedType(ReceiptDocTypeFilterOption type) {
    state = type;
    ref.read(offsetProvider.notifier).state = receiptsFetchLimit;
  }
}

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

// The offset amount for the fetchMoreReceipts call in the Receipts class
final offsetProvider = StateProvider<int>((ref) {
  return receiptsFetchLimit;
});

@riverpod
class Receipts extends _$Receipts {
  // Make sure docType is fully lowercase to avoid errors
  @override
  Future<List<ReceiptDownloadOption>> build(String docType) async {
    return getReceipts(
      docType: docType,
    );
  }

  Future<void> fetchMoreReceipts(String docType) async {
    await Future.delayed(
      const Duration(seconds: 3),
    ); // Used this to simulate loading time
    final offset = ref.read(offsetProvider.notifier).state;
    final newReceipts = await getReceipts(docType: docType, offset: offset);
    final currState = await future;

    state = AsyncValue.data([...currState, ...newReceipts]);
    ref.read(offsetProvider.notifier).state += receiptsFetchLimit;
  }
}
