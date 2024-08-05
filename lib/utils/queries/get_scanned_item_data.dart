import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';

Future<ScannedItem> getScannedItemData(
  String barcode,
  String docType,
  String docNo,
) async {
  ({String itemCode, BarcodeValueTypes barcodeValType}) itemCodeData;

  try {
    itemCodeData = await verifyBarcode(barcode);
  } catch (err) {
    return Future.error(err.toString());
  }

  // Check if the current task has this item on it
  Database localDb = await LocalDatabaseHelper.instance.database;
  final itemData = await localDb.rawQuery('''SELECT item_code, item_name,
                                         SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                         FROM task_item
                                         WHERE doc_no = '${docNo.trim()}' 
                                         AND doc_type = '${docType.trim()}'
                                         AND item_code = '${itemCodeData.itemCode}'
                                         GROUP BY item_code, item_name
                                         ORDER BY (qty_required / qty_collected)''');
  if (itemData.isEmpty) {
    return Future.error(
      "Barcode is valid, but could not find matching item in current task",
    );
  }

  final item = itemData[0];
  final taskItem = TaskItem(
    itemCode: itemCodeData.itemCode,
    itemName: item["item_name"].toString(),
    qtyRequired: int.parse(item["qty_required"].toString()),
    qtyCollected: int.parse(item["qty_collected"].toString()),
  );

  return ScannedItem(
    taskItem: taskItem,
    barcode: barcode,
    barcodeValueType: itemCodeData.barcodeValType,
  );
}

// Get the matching item code and the type of the abrcode value
Future<({String itemCode, BarcodeValueTypes barcodeValType})> verifyBarcode(
  String barcode,
) async {
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
      itemCode: matchingItems[0]["item_code"].toString(),
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
    throw ErrorDescription(
      "Couldn't check for matching serial number, no matching item codes found",
    );
  }

  throw ErrorDescription(
    "No matching item codes found",
  );
}
