import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/utils/helpers/doc_type_helpers.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

// Downloads data relevant to one receipt
Future<void> downloadReceipt(
  String parentType,
  String docType,
  String docNo,
) async {
  // Since there are some cases where the parent type doesn't match the table name + when the,
  // docType doesn't match the docType column (for trx table), we use these functions

  // More details in doc_type_helpers.dart
  final tableName = getTableName(parentType);
  final docTypeColPrefix = getDocTypeColPrefix(parentType);

  List<dynamic> taskAndTaskItemData = await getTaskAndTaskItemData(
    tableName: tableName,
    docType: docType,
    parentType: parentType,
    docNo: docNo,
    docTypeColPrefix: docTypeColPrefix,
  );

  List<dynamic> itemBarcodes = await getItemBarcodes(
    tableName: tableName,
    docType: docType,
    docNo: docNo,
    parentType: parentType,
    docTypeColPrefix: docTypeColPrefix,
  );

  Database localDb = await LocalDatabaseHelper.instance.database;
  final cleanedParentType = parentType.toUpperCase().replaceAll(' ', '');
  final insertNewTaskQuery =
      '''INSERT INTO task (doc_no, doc_type, parent_type, trx_no)
                                  VALUES ('$docNo', '$docType', '$cleanedParentType',  'SC0001')''';

  try {
    await localDb.execute("BEGIN TRANSACTION;");
    await localDb.rawInsert(insertNewTaskQuery);
    await saveTaskAndTaskItemData(
      taskAndTaskItemData: taskAndTaskItemData,
      docType: docType,
      docNo: docNo,
    );
    await saveBarcodeData(
      itemBarcodes: itemBarcodes,
    );
    await localDb.execute("COMMIT TRANSACTION;");
  } catch (err) {
    localDb.execute("ROLLBACK;");
    throw ErrorDescription(err.toString());
  }
}

Future<void> saveTaskAndTaskItemData({
  required List<dynamic> taskAndTaskItemData,
  required String docType,
  required String docNo,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  for (final receiptData in taskAndTaskItemData) {
    final itemName = receiptData["item_name"];
    final itemCode = receiptData["item_code"];
    final qtyRequired = receiptData["qty"];

    localDb.rawInsert(
        '''INSERT INTO task_item (doc_type, doc_no, item_code, item_name, qty_required)
                                        VALUES ('$docType', '$docNo', '$itemCode', '$itemName', $qtyRequired);''');
  }
}

Future<void> saveBarcodeData({
  required List<dynamic> itemBarcodes,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  for (final data in itemBarcodes) {
    final itemBarcode = data["item_barcode"];
    final itemCode = data["item_code"];

    localDb.execute('''INSERT INTO item_barcode (item_barcode, item_code)
                         VALUES ('$itemBarcode', '$itemCode');''');
  }
}

Future<List<dynamic>> getTaskAndTaskItemData({
  required String tableName,
  required String docType,
  required String parentType,
  required String docNo,
  required String docTypeColPrefix,
}) async {
  final getItemsQuery = '''SELECT d.item_code,
                                    d.item_name,
                                    ISNULL(SUM(d.${getQtyColName(parentType)}), 0) AS qty
                              FROM   ${tableName}_hdr h
                              JOIN ${tableName}_dat d ON ${getReceiptDataJoinCondition(parentType)}
                              WHERE h.${docTypeColPrefix}_type = '$docType'
                                    AND h.${tableName}_no = '$docNo'
                                    AND d.item_name IS NOT NULL
                                    AND d.item_code IS NOT NULL
                              GROUP  BY d.item_code,
                                        d.item_name''';

  final res = await ApiService.executeSQLQuery(
    null,
    [
      ApiService.sqlQueryParm(getItemsQuery),
    ],
  );

  return ApiService.sqlQueryResult(res);
}

Future<List<dynamic>> getItemBarcodes({
  required String tableName,
  required String docType,
  required String docNo,
  required String parentType,
  required String docTypeColPrefix,
}) async {
  final docTypeColPrefix = getDocTypeColPrefix(tableName);
  final getBarcodesQuery = '''SELECT ib.item_barcode,
                                    ib.item_code
                              FROM   item_barcode ib
                              WHERE  ib.item_code IN (SELECT DISTINCT d.item_code
                                                      FROM   ${tableName}_hdr h
                                                      JOIN ${tableName}_dat d ON ${getReceiptDataJoinCondition(parentType)}
                                                      WHERE h.${tableName}_no = '$docNo'
                                                      AND h.${docTypeColPrefix}_type = '$docType'); ''';

  final res = await ApiService.executeSQLQuery(
    null,
    [
      ApiService.sqlQueryParm(getBarcodesQuery),
    ],
  );

  return ApiService.sqlQueryResult(res);
}
