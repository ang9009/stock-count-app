import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

Future<ScannedItem> getScannedItemData(
  String barcode,
  String docType,
  String docNo,
  bool allowUnknown,
) async {
  ({String? itemCode, BarcodeValueTypes barcodeValType}) itemCodeData;

  try {
    itemCodeData = await verifyBarcode(
      barcode: barcode,
      allowUnknown: allowUnknown,
    );
  } catch (err) {
    return Future.error(err.toString());
  }

  Database localDb = await LocalDatabaseHelper.instance.database;

  // Check if the current task has this item on it
  List<Map> currReceiptItemData;
  try {
    currReceiptItemData = await localDb.rawQuery('''SELECT item_code, item_name,
                                         SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                         FROM task_item
                                         WHERE doc_no = '${docNo.trim()}' 
                                         AND doc_type = '${docType.trim()}'
                                         AND item_code ${itemCodeData.itemCode == null ? '''IS NULL''' : "= '${itemCodeData.itemCode}'"}
                                         ${itemCodeData.barcodeValType == BarcodeValueTypes.unknown ? '''AND item_barcode = '$barcode' ''' : ""}
                                         GROUP BY item_code, item_name
                                         ORDER BY (qty_required / qty_collected)''');
  } catch (err) {
    return Future.error(
      "An unexpected error occurred: ${err.toString()}",
    );
  }

  if (currReceiptItemData.isEmpty && !allowUnknown) {
    return Future.error(
      "Barcode is valid, but could not find matching item in current task",
    );
  }

  bool itemDataExists = currReceiptItemData.isNotEmpty;

  final taskItem = TaskItem(
    itemCode: itemCodeData
        .itemCode, // This is null if the item type is unknown (see verifyBarcode last return)
    itemName: itemDataExists
        ? currReceiptItemData[0]["item_name"].toString()
        : unknownItemName,
    qtyRequired: itemDataExists
        ? int.parse(currReceiptItemData[0]["qty_required"].toString())
        : null,
    qtyCollected: itemDataExists
        ? int.parse(currReceiptItemData[0]["qty_collected"].toString())
        : 0,
  );

  return ScannedItem(
    taskItem: taskItem,
    barcode: barcode,
    barcodeValueType: itemCodeData.barcodeValType,
  );
}

// Get the matching item code and the type of the barcode value
Future<({String? itemCode, BarcodeValueTypes barcodeValType})> verifyBarcode({
  required String barcode,
  required bool allowUnknown,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  // Check for matching saved item barcodes
  final matchingItems =
      await localDb.rawQuery('''SELECT item_code FROM item_barcode 
                                WHERE item_barcode = '$barcode' 
                                LIMIT 1;''');
  if (matchingItems.isNotEmpty) {
    return (
      itemCode: matchingItems[0]["item_code"].toString(),
      barcodeValType: BarcodeValueTypes.barcode,
    );
  }

  // Check if barcode value is the item code
  final matchingItemCode =
      await localDb.rawQuery('''SELECT item_code FROM task_item 
                                WHERE item_code = '$barcode' 
                                LIMIT 1;''');
  if (matchingItemCode.isNotEmpty) {
    return (
      itemCode: matchingItemCode[0]["item_code"].toString(),
      barcodeValType: BarcodeValueTypes.itemCode,
    );
  }

  // Check if the barcode value is the serial number
  try {
    final serialQuery = '''SELECT item_code FROM serial_info 
                           WHERE lot_no = '$barcode';''';

    final res = await ApiService.executeSQLQuery(
      null,
      [
        ApiService.sqlQueryParm(serialQuery),
      ],
    );
    final matchingSerials = ApiService.sqlQueryResult(res);

    if (matchingSerials.isNotEmpty) {
      return (
        itemCode: matchingItems[0]["item_code"].toString(),
        barcodeValType: BarcodeValueTypes.lotNo,
      );
    }
  } catch (err) {
    if (!allowUnknown) {
      throw ErrorDescription(
        "Couldn't check for matching serial number, no matching item codes found",
      );
    }
  }

  if (!allowUnknown) {
    throw ErrorDescription(
      "No matching item codes, barcodes, or serial numbers found",
    );
  }

  // If the item type is unknown, then the item code is null
  return (itemCode: null, barcodeValType: BarcodeValueTypes.unknown);
}
