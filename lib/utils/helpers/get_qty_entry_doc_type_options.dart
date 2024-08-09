import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

Future<List<QtyEntryDocTypeOption>> getQtyEntryDocTypeOptions() async {
  List<Map<String, Object?>> res;

  try {
    Database localDb = await LocalDatabaseHelper.instance.database;
    const query = '''SELECT doc_type, doc_desc, parent_type
                     FROM stock_count_control
                     WHERE need_ref_no = 'N';''';
    res = await localDb.rawQuery(query);
  } catch (err) {
    return Future.error("An unexpected error occurred: ${err.toString()}");
  }

  final options = res
      .map(
        (optionData) => QtyEntryDocTypeOption(
          docType: optionData["doc_type"].toString(),
          docDesc: optionData["doc_desc"].toString(),
          parentType: optionData["parent_type"].toString(),
        ),
      )
      .toList();

  return options;
}
