import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<void> initializeSettings({
  required String deviceId,
  required String apiUrl,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final sanitizedId = deviceId.replaceAll(" ", "");

  //  Default settings included
  await localDb.rawInsert(
    '''INSERT INTO settings (enable_serial, enable_bin, device_id, api_url, counter_no)
         VALUES (1, 1, '$sanitizedId', '$apiUrl', 0)''',
  );
}
