import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/get_doc_type_options.dart';
import 'package:stock_count/utils/queries/get_receipts.dart';

part 'receipt_list_providers.g.dart';

@riverpod
Future<List<ReceiptDocTypeFilterOption>> docTypes(DocTypesRef ref) async {
  return await getDocTypeOptions();
}

@riverpod
class SelectedReceiptType extends _$SelectedReceiptType {
  @override
  ReceiptDocTypeFilterOption? build() {
    final types = ref.watch(docTypesProvider);

    if (types.hasValue) {
      return types.requireValue[0];
    }

    return null;
  }

  void setSelectedType(ReceiptDocTypeFilterOption type) {
    log(type.docDesc);
    state = type;
  }
}

@riverpod
class SelectedReceipts extends _$SelectedReceipts {
  @override
  Set<ReceiptDownloadOption> build() {
    return {};
  }

  void selectAllReceipts(List<ReceiptDownloadOption> receipts) {
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
