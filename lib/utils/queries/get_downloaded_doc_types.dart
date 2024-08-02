import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';

Future<List<String>> getDownloadedDocTypes() async {
  Database localDb = await LocalDbHelper.instance.database;
  List<Map<String, Object?>> docTypesData =
      await localDb.rawQuery("SELECT DISTINCT doc_type FROM task");

  return docTypesData
      .map<String>((data) => data["doc_type"] as String)
      .toList();
}
