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
  }
}

@riverpod
class SelectedReceipts extends _$SelectedReceipts {
  @override
  Set<ReceiptDownloadOption> build() {
    return {};
  }

  void selectAllReceipts(
      String currDocType, List<ReceiptDownloadOption> receipts) {
    state = {...receipts};
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
