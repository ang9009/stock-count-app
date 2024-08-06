import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<bool> getDocTypeAllowUnknown(String docType) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final sanitizedDocType = docType.toUpperCase().replaceAll(' ', '');

  final res = await localDb.rawQuery(
    "SELECT allow_unknown FROM stock_count_control WHERE doc_type = '$docType'",
  );

  return res[0]["allow_unknown"].toString() == "Y";
}
