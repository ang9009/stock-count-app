import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<bool> settingsIsPopulated() async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final res = await localDb.rawQuery("SELECT COUNT(*) AS count FROM settings");

  if (res[0]["count"].toString() == "0") {
    return false;
  } else {
    return true;
  }
}
