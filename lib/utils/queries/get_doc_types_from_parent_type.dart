import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<List<String>?> getDocTypesFromParentType(String parentType) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  String sanitizedParentType = parentType.toUpperCase().replaceAll(" ", "");

  final res = await localDb.rawQuery('''SELECT doc_type FROM stock_count_control
                                  WHERE parent_type = '$sanitizedParentType';''');

  if (res.isNotEmpty) {
    return res.map((data) => data["doc_type"].toString()).toList();
  } else {
    return null;
  }
}
