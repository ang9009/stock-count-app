// exist bin_no, exist lot_no, exist

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

Future<void> updateScannedItemQuantity({
  required ScannedItem item,
  required String docType,
  required String docNo,
  required String? binNo,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  final whereCondition = _getWhereCondition(
    item: item,
    docType: docType,
    docNo: docNo,
    binNo: binNo,
  );

  List<Map> matchingItemVariants;

  try {
    final getMatchingItemsQuery = '''SELECT COUNT(1) AS count
                                     FROM task_item
                                     $whereCondition''';
    matchingItemVariants = await localDb.rawQuery(getMatchingItemsQuery);
  } catch (err) {
    throw ErrorDescription("An unexpected error occurred: ${err.toString()}");
  }

  final matchingItemsCount =
      int.parse(matchingItemVariants[0]["count"].toString());

  try {
    final itemData = item.taskItem;
    String itemBarcode = switch (item.barcodeValueType) {
      BarcodeValueTypes.barcode => item.barcode,
      BarcodeValueTypes.unknown => item.barcode,
      _ => "NULL",
    };
    String itemCode =
        itemData.itemCode != null ? "'${itemData.itemCode}'" : '''NULL''';
    String lotNo = item.barcodeValueType == BarcodeValueTypes.lotNo
        ? "'${item.barcode}'"
        : '''NULL''';
    String binNoVal = binNo != null ? "'$binNo'" : '''NULL''';

    if (matchingItemsCount == 0) {
      await localDb.rawInsert(
          '''INSERT INTO task_item (doc_type, doc_no, item_code, item_name, item_barcode, lot_no, bin_no, qty_collected)
           VALUES ('$docType', '$docNo', $itemCode, '${itemData.itemName}', $itemBarcode, $lotNo, $binNoVal, 1);''');
    } else {
      await localDb.rawUpdate('''UPDATE task_item
                               SET qty_collected = qty_collected + 1
                               $whereCondition''');
    }
  } catch (err) {
    throw ErrorDescription("An unexpected error occurred: ${err.toString()}");
  }
}

String _getWhereCondition({
  required ScannedItem item,
  required String docType,
  required String docNo,
  required String? binNo,
}) {
  log(item.barcodeValueType.toString());
  String barcodeAndSerialReq = switch (item.barcodeValueType) {
    BarcodeValueTypes.barcode =>
      "AND item_barcode = '${item.barcode}' AND lot_no IS NULL",
    BarcodeValueTypes.lotNo =>
      "AND lot_no = '${item.barcode}' AND item_barcode IS NULL",
    BarcodeValueTypes.itemCode => "AND lot_no IS NULL AND item_barcode IS NULL",
    BarcodeValueTypes.unknown =>
      "AND item_barcode = '${item.barcode}' AND lot_no IS NULL"
  };

  // If itemCode is null, that means the barcode type is unknown
  final itemData = item.taskItem;
  return '''WHERE doc_type = '$docType' 
           AND doc_no = '$docNo'
           AND item_code ${itemData.itemCode != null ? "= '${itemData.itemCode}'" : '''IS NULL'''}
           AND bin_no ${binNo != null ? "= '$binNo'" : '''IS NULL'''}
           AND qty_required = 0
           $barcodeAndSerialReq''';
}
