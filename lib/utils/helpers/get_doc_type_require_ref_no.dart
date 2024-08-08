import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<bool> getDocTypeNeedRefNo(String parentType) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final sanitizedParentType = parentType.toUpperCase().replaceAll(' ', '');

  final res = await localDb.rawQuery(
    "SELECT need_ref_no FROM stock_count_control WHERE parent_type = '$sanitizedParentType'",
  );

  return res[0]["need_ref_no"].toString() == "Y";
}
