import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/queries/get_curr_trx_no.dart';

Future<void> createQuantityEntryTask({
  required String parentType,
  required String docType,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  final transactionNo = await getCurrTransactionNumber();
  final insertTaskQuery =
      '''INSERT INTO task (doc_no, doc_type, parent_type, trx_no)
         VALUES ('$transactionNo', '$docType', '$parentType', '$transactionNo');''';
  const updateCounterNoQuery = '''UPDATE settings 
                                  SET counter_no = counter_no + 1;''';

  try {
    await localDb.execute("BEGIN TRANSACTION;");
    await localDb.rawInsert(insertTaskQuery);
    // Update counter number
    await localDb.rawUpdate(updateCounterNoQuery);
    await localDb.execute("COMMIT TRANSACTION;");
  } catch (err) {
    await localDb.execute("ROLLBACK;");
    return Future.error("An error occurred: ${err.toString()}");
  }
}
