import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';

Future<void> updateLastUpdated(
    {required String docNo, required String docType}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  await localDb.rawUpdate('''UPDATE task 
                       SET last_updated = DATETIME('NOW') 
                       WHERE doc_no = '$docNo' AND doc_type = '$docType';''');
}
