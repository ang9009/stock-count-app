// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_item_variants.dart';

part 'item_variants_provider.g.dart';

@riverpod
int totalQtyCollected(
  TotalQtyCollectedRef ref, {
  required String itemCode,
  required String docNo,
  required String docType,
}) {
  final itemVariants = ref.watch(
    itemVariantsProvider(
      docNo: docNo,
      itemCode: itemCode,
      docType: docType,
    ),
  );

  if (itemVariants.hasError) {
    log("There was an issue in fetching items while trying to get the total qty collected");
    return 0;
  } else if (itemVariants.hasValue) {
    int qtyCollected = 0;
    for (final item in itemVariants.requireValue) {
      qtyCollected += item.qtyCollected;
    }
    return qtyCollected;
  } else {
    log("Attempted to get total qty collected while items are still being fetched");
    return 0;
  }
}

@riverpod
class ItemVariants extends _$ItemVariants {
  @override
  Future<List<ItemVariant>> build({
    required String itemCode,
    required String docNo,
    required String docType,
  }) async {
    return await getItemVariants(
      itemCode: itemCode,
      docNo: docNo,
      docType: docType,
    );
  }

  Future<int> _getItemIndex({required ItemVariant item}) async {
    final currState = await future;
    final itemIndex = currState.indexWhere((currItem) => currItem == item);

    return itemIndex;
  }

  void setItemQtyCollected({
    required ItemVariant item,
    required int qty,
  }) async {
    final currState = await future;
    final itemIndex = await _getItemIndex(item: item);

    currState[itemIndex] = ItemVariant(
      binNo: currState[itemIndex].binNo,
      itemCode: currState[itemIndex].itemCode,
      itemBarcode: currState[itemIndex].itemBarcode,
      lotNo: currState[itemIndex].lotNo,
      qtyCollected: qty,
      barcodeValueType: currState[itemIndex].barcodeValueType,
    );

    state = AsyncValue.data(currState);
  }

  void updateItemQtyCollected({
    required ItemVariant item,
    required bool increment,
  }) async {
    final currState = await future;
    final itemIndex = await _getItemIndex(item: item);

    final difference = increment ? 1 : -1;
    currState[itemIndex] = ItemVariant(
      binNo: currState[itemIndex].binNo,
      itemCode: currState[itemIndex].itemCode,
      itemBarcode: currState[itemIndex].itemBarcode,
      lotNo: currState[itemIndex].lotNo,
      qtyCollected: currState[itemIndex].qtyCollected + difference,
      barcodeValueType: currState[itemIndex].barcodeValueType,
    );

    state = AsyncValue.data(currState);
  }

  Future<List<ItemVariant>> getMoreItemVariants({
    required String docType,
    required String docNo,
    required int offset,
  }) async {
    final currState = await future;
    final addedItems = await getItemVariantsWithOffset(
      itemCode: itemCode,
      docNo: docNo,
      docType: docType,
      offset: offset,
    );

    state = AsyncValue.data([...currState, ...addedItems]);
    return addedItems;
  }

  void removeItem(ItemVariant item) async {
    final currState = await future;
    state = AsyncValue.data(
      currState.where((currItem) => currItem != item).toList(),
    );
  }
}
