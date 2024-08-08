import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/api/services/web_service.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<void> downloadStockCountControl() async {
  const query =
      '''SELECT doc_type, doc_desc, parent_type, need_ref_no, allow_unknown
         FROM stock_count_control''';
  final ApiResponse res;

  try {
    res = await ApiService.executeSQLQuery(null, [
      ApiService.sqlQueryParm(query),
    ]);
  } catch (err) {
    debugPrint("Could not get data to update stock count control");
    return;
  }

  final resData = ApiService.sqlQueryResult(res);
  final Database localDb = await LocalDatabaseHelper.instance.database;
  try {
    await localDb.execute("BEGIN TRANSACTION");
    for (final data in resData) {
      final docType = data["doc_type"].toString();
      final docDesc = data["doc_desc"].toString();
      final parentType = data["parent_type"].toString();
      final needRefNo = data["need_ref_no"].toString();
      final allowUnknown = data["allow_unknown"].toString();

      await localDb.rawInsert(
          '''INSERT OR REPLACE INTO stock_count_control (doc_type, doc_desc, parent_type, need_ref_no, allow_unknown)
           VALUES ('$docType', '$docDesc', '$parentType', '$needRefNo', '$allowUnknown');''');
    }
    await localDb.execute("COMMIT TRANSACTION");
  } catch (err) {
    localDb.execute("ROLLBACK;");
    throw ErrorDescription(err.toString());
  }
}
