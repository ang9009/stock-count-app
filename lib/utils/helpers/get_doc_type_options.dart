import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

Future<List<ReceiptDocTypeFilterOption>> getDocTypeOptions() async {
  List<Map<String, Object?>> res;

  try {
    Database localDb = await LocalDatabaseHelper.instance.database;
    res = await localDb.rawQuery('''SELECT DISTINCT doc_desc, parent_type
             FROM stock_count_control
             WHERE need_ref_no = 'Y';''');
  } catch (err) {
    return Future.error("An unexpected error occurred: ${err.toString()}");
  }

  final options = res
      .map(
        (optionData) => ReceiptDocTypeFilterOption(
          docDesc: optionData["doc_desc"].toString(),
          parentType: optionData["parent_type"].toString(),
        ),
      )
      .toList();

  return options;
}
