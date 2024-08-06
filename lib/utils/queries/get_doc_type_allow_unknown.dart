import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<bool> getDocTypeAllowUnknown(String parentType) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final sanitizedParentType = parentType.toUpperCase().replaceAll(' ', '');

  final res = await localDb.rawQuery(
    "SELECT allow_unknown FROM stock_count_control WHERE parent_type = '$sanitizedParentType'",
  );

  return res[0]["allow_unknown"].toString() == "Y";
}
