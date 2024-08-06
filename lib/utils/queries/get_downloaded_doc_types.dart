import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<List<String>> getDownloadedDocTypes() async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  List<Map<String, Object?>> docTypesData =
      await localDb.rawQuery("SELECT DISTINCT doc_type FROM task");

  return docTypesData
      .map<String>((data) => data["doc_type"] as String)
      .toList();
}
