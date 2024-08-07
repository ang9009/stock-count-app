import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<List<String>> getParentTypeOptions() async {
  List<Map<String, Object?>> res;

  try {
    Database localDb = await LocalDatabaseHelper.instance.database;
    res = await localDb.rawQuery('''SELECT DISTINCT parent_type
             FROM stock_count_control
             WHERE need_ref_no = 'N';''');
  } catch (err) {
    return Future.error("An unexpected error occurred: ${err.toString()}");
  }

  final options = res
      .map(
        (optionData) => optionData["parent_type"].toString(),
      )
      .toList();

  return options;
}
