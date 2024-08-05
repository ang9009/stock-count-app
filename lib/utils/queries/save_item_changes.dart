import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';

Future<void> saveItemChanges(
  Map<ItemVariant, int> itemChanges,
  String docNo,
  String docType,
) async {
  final Database localDb = await LocalDatabaseHelper.instance.database;

  try {
    await localDb.execute("BEGIN TRANSACTION;");
    for (final itemData in itemChanges.entries) {
      final item = itemData.key;
      final qtyCollected = itemData.value;

      String whereClause = '''WHERE doc_no = '$docNo' 
             AND doc_type = '$docType' 
             AND item_code = '${item.itemCode}' 
             AND bin_no = '${item.binNo}'
             AND item_barcode ${item.itemBarcode != null ? "= '${item.itemBarcode}'" : "IS NULL"}
             AND lot_no ${item.lotNo != null ? "= '${item.lotNo}'" : "IS NULL"}''';

      // If the qtyCollected is -1, that means the item should be deleted
      if (qtyCollected == -1) {
        await localDb.rawDelete('''DELETE FROM task_item 
                                   $whereClause''');
      } else {
        log('''UPDATE task_item
              SET qty_collected = $qtyCollected
              $whereClause''');
        await localDb.rawUpdate('''UPDATE task_item
                                   SET qty_collected = $qtyCollected
                                   $whereClause''');
      }
    }
    await localDb.execute("COMMIT TRANSACTION;");
  } catch (err) {
    localDb.execute("ROLLBACK;");
    throw ErrorDescription(err.toString());
  }
}
