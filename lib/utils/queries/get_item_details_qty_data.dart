import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';

Future<({int qtyCollected, int qtyRequired})> getItemDetailsQtyData({
  required String itemCode,
  required String docType,
  required String docNo,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  final res = await localDb.rawQuery(
      '''SELECT SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
         FROM task_item
         WHERE item_code = '$itemCode' 
         AND doc_type = '$docType' 
         AND doc_no = '$docNo'
         GROUP BY item_code, doc_type, doc_no
    ''');

  return (
    qtyCollected: res[0]["qty_collected"] as int,
    qtyRequired: res[0]["qty_required"] as int,
  );
}

Future<int> getItemQtyRequired({
  required String itemCode,
  required String docType,
  required String docNo,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  final res = await localDb.rawQuery('''SELECT SUM(qty_required) AS qty_required
      FROM task_item
      WHERE item_code = '$itemCode' 
      AND doc_type = '$docType' 
      AND doc_no = '$docNo'
      GROUP BY item_code, doc_type, doc_no
    ''');

  return res[0]["qty_required"] as int;
}
