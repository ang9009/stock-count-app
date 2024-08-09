// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

// Main function
Future<ScannedItem> getScannedItemData({
  required String barcode,
  required String docType,
  required String docNo,
  required bool allowUnknown,
  required bool needRefNo,
}) async {
  try {
    ItemCodeData itemCodeData = await getItemCodeData(
      barcode: barcode,
      allowUnknown: allowUnknown,
      needRefNo: needRefNo,
      docNo: docNo,
      docType: docType,
    );

    // If needRefNo is true (item task data), check if the current task has this item on it
    if (needRefNo) {
      return await getScannedItemFromCurrentTask(
        itemCodeData: itemCodeData,
        docNo: docNo,
        docType: docType,
        barcode: barcode,
        allowUnknown: allowUnknown,
      );
    } else {
      // If need ref no is false (no saved item data), try to look for the item online
      return await getScannedItemFromExternalDb(
        itemCodeData: itemCodeData,
        barcode: barcode,
        allowUnknown: allowUnknown,
        docNo: docNo,
        docType: docType,
      );
    }
  } catch (err) {
    throw ErrorDescription(err.toString());
  }
}

Future<ScannedItem> getScannedItemFromExternalDb({
  required ItemCodeData itemCodeData,
  required String barcode,
  required bool allowUnknown,
  required String docNo,
  required String docType,
}) async {
  final String itemName;

  // If the item code is null and allowUnknown is set to true, the item name is unknown
  if (itemCodeData.barcodeValueType == BarcodeValueTypes.unknown &&
      allowUnknown) {
    itemName = unknownItemName;
  } else {
    // Get item name online using item code, which was fetched earlier in checkExternalDbForMatchingCodes
    final itemNameQuery = '''SELECT TOP 1 item_name 
                           FROM item
                           WHERE item_code = '${itemCodeData.itemCode}';''';
    List<dynamic> itemNameData;

    final itemNameRes = await ApiService.executeSQLQuery(
      null,
      [
        ApiService.sqlQueryParm(itemNameQuery),
      ],
    );
    itemNameData = ApiService.sqlQueryResult(itemNameRes);
    itemName = itemNameData[0]["item_name"];
  }

  // Try to get qty collected so far
  Database localDb = await LocalDatabaseHelper.instance.database;
  final currQtyCollectedQuery = '''SELECT SUM(qty_collected) AS qty_collected
                                   FROM task_item
                                   WHERE item_code = '${itemCodeData.itemCode}'
                                   AND doc_no = '$docNo'
                                   AND doc_type = '$docType';''';
  final qtyCollectedRes = await localDb.rawQuery(currQtyCollectedQuery);
  final qtyCollected = qtyCollectedRes[0]["qty_collected"] == null
      ? 0
      : qtyCollectedRes[0]["qty_collected"] as int;

  final taskItem = TaskItem(
    itemCode: itemCodeData.itemCode,
    itemName: itemName,
    qtyRequired: null,
    qtyCollected: qtyCollected,
  );

  return ScannedItem(
    taskItem: taskItem,
    barcode: barcode,
    barcodeValueType: itemCodeData.barcodeValueType,
  );
}

Future<ScannedItem> getScannedItemFromCurrentTask({
  required ItemCodeData itemCodeData,
  required String docNo,
  required String docType,
  required String barcode,
  required bool allowUnknown,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  List<Map> itemData;

  try {
    final currReceiptItemsQuery = '''SELECT item_code, item_name,
                                     SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                     FROM task_item
                                     WHERE doc_no = '${docNo.trim()}' AND doc_type = '${docType.trim()}'
                                     AND item_code = '${itemCodeData.itemCode}'
                                    ${itemCodeData.barcodeValueType == BarcodeValueTypes.unknown ? '''AND item_barcode = '$barcode' ''' : ""}
                                    GROUP BY item_code, item_name
                                    ORDER BY (qty_required / qty_collected)''';
    itemData = await localDb.rawQuery(currReceiptItemsQuery);
  } catch (err) {
    throw ErrorDescription(
      "An unexpected error occurred: ${err.toString()}",
    );
  }

  if (itemData.isEmpty && !allowUnknown) {
    throw ErrorDescription(
      "Barcode is valid, but could not find matching item in current task",
    );
  }

  bool itemDataExists = itemData.isNotEmpty;

  final taskItem = TaskItem(
    itemCode: itemCodeData
        .itemCode, // This is null if the item type is unknown (see verifyBarcode last return)
    itemName:
        itemDataExists ? itemData[0]["item_name"].toString() : unknownItemName,
    qtyRequired: itemDataExists
        ? int.parse(itemData[0]["qty_required"].toString())
        : null,
    qtyCollected:
        itemDataExists ? int.parse(itemData[0]["qty_collected"].toString()) : 0,
  );

  return ScannedItem(
    taskItem: taskItem,
    barcode: barcode,
    barcodeValueType: itemCodeData.barcodeValueType,
  );
}

// Get the matching item code and the type of the barcode value (if possible). If not, throws an error
Future<ItemCodeData> getItemCodeData({
  required String barcode,
  required bool allowUnknown,
  required bool needRefNo,
  required String docNo,
  required String docType,
}) async {
  // If the document type has "need_ref_no" flagged as false, then it has no saved item data, so
  // matching barcodes/item codes must be evaluated using the external database
  if (!needRefNo) {
    try {
      final itemCodeData = await checkExternalDbForMatchingCodes(
        barcode: barcode,
      );
      if (itemCodeData != null) return itemCodeData;
    } catch (err) {
      throw ErrorDescription(
        "Couldn't check for matching codes due to the following error: ${err.toString()}",
      );
    }
  } else {
    // If "need_ref_no" is not flagged as true, check the local database for matching barcodes/item codes
    final itemCodeData = await checkLocalDbForMatchingCodes(
      docNo: docNo,
      docType: docType,
      barcode: barcode,
    );
    if (itemCodeData != null) return itemCodeData;
  }

  // Check if the barcode value is the serial number
  try {
    final itemCodeData = await checkExternalDbForSerialNumber(barcode);
    if (itemCodeData != null) return itemCodeData;
  } catch (err) {
    // If the document doesn't allow unknown items, throw appropriate error (since at this point, all possible
    // checks have been completed)
    if (!allowUnknown) {
      throw ErrorDescription(
        "No matching item codes found matching serial no. check failed: ${err.toString()}",
      );
    }
  }

  if (!allowUnknown) {
    throw ErrorDescription(
      "No matching item codes, barcodes, or serial numbers found",
    );
  } else {
    // If the item type is unknown, then the item code is null
    return ItemCodeData(
      itemCode: barcode,
      barcodeValueType: BarcodeValueTypes.unknown,
    );
  }
}

Future<ItemCodeData?> checkExternalDbForMatchingCodes({
  required String barcode,
}) async {
  try {
    // Check for matching barcodes from item_barcode
    final barcodeQuery = '''SELECT TOP 1 item_code FROM item_barcode
                           WHERE item_barcode = '$barcode';''';
    final barcodeRes = await ApiService.executeSQLQuery(
      null,
      [
        ApiService.sqlQueryParm(barcodeQuery),
      ],
    );
    final matchingCodesFromItemBarcode = ApiService.sqlQueryResult(barcodeRes);
    if (matchingCodesFromItemBarcode.isNotEmpty) {
      return ItemCodeData(
        itemCode: matchingCodesFromItemBarcode[0]["item_code"],
        barcodeValueType: BarcodeValueTypes.barcode,
      );
    }

    // Check for matching barcodes from item master table
    final itemCodeQuery = '''SELECT TOP 1 item_code FROM item
                           WHERE item_code = '$barcode';''';
    final itemCodeRes = await ApiService.executeSQLQuery(
      null,
      [
        ApiService.sqlQueryParm(itemCodeQuery),
      ],
    );
    final matchingCodesFromItem = ApiService.sqlQueryResult(itemCodeRes);
    if (matchingCodesFromItem.isNotEmpty) {
      return ItemCodeData(
        itemCode: matchingCodesFromItem[0]["item_code"],
        barcodeValueType: BarcodeValueTypes.itemCode,
      );
    }
  } catch (err) {
    return ItemCodeData(
      itemCode: barcode,
      barcodeValueType: BarcodeValueTypes.unknown,
    );
  }

  // If nothing was found, return null
  return null;
}

Future<ItemCodeData?> checkExternalDbForSerialNumber(String barcode) async {
  final serialQuery = '''SELECT TOP 1 item_code FROM item_serial
                           WHERE serial_no = '$barcode';''';

  final res = await ApiService.executeSQLQuery(
    null,
    [
      ApiService.sqlQueryParm(serialQuery),
    ],
  );
  final matchingSerials = ApiService.sqlQueryResult(res);

  if (matchingSerials.isNotEmpty) {
    return ItemCodeData(
      itemCode: matchingSerials[0]["item_code"].toString(),
      barcodeValueType: BarcodeValueTypes.lotNo,
    );
  } else {
    return null;
  }
}

Future<ItemCodeData?> checkLocalDbForMatchingCodes({
  required String barcode,
  required String docNo,
  required String docType,
}) async {
  // Check for matching saved item barcodes
  Database localDb = await LocalDatabaseHelper.instance.database;
  final matchingItems =
      await localDb.rawQuery('''SELECT item_code FROM item_barcode 
                                WHERE item_barcode = '$barcode' 
                                LIMIT 1;''');
  if (matchingItems.isNotEmpty) {
    return ItemCodeData(
      itemCode: matchingItems[0]["item_code"].toString(),
      barcodeValueType: BarcodeValueTypes.barcode,
    );
  }

  // Check if barcode value is the item code
  final matchingItemCode =
      await localDb.rawQuery('''SELECT item_code FROM task_item 
                                WHERE item_code = '$barcode' 
                                AND doc_no = '$docNo'
                                AND doc_type = '$docType'
                                LIMIT 1;''');
  if (matchingItemCode.isNotEmpty) {
    return ItemCodeData(
      itemCode: matchingItemCode[0]["item_code"].toString(),
      barcodeValueType: BarcodeValueTypes.itemCode,
    );
  }

  // If nothing was found, return null
  return null;
}
