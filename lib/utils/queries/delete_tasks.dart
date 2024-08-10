import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

Future<void> deleteTasks(List<Task> tasks) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  try {
    await localDb.rawQuery('''BEGIN TRANSACTION;''');
    for (final task in tasks) {
      final deleteQuery = '''DELETE FROM task 
             WHERE doc_no = '${task.docNo}'
             AND doc_type = '${task.docType}';''';
      await localDb.rawDelete(deleteQuery);
    }
    await localDb.rawQuery('''COMMIT TRANSACTION;''');
  } catch (err) {
    await localDb.rawQuery('''ROLLBACK;''');
    throw ErrorDescription("An error occurred: ${err.toString()}");
  }
}
