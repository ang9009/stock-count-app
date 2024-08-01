import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/initialize_db.dart';

const int taskItemsFetchLimit = 20;

Future<List<TaskItem>> getTaskItems(String docType, String docNo) async {
  Database localDb = await getDatabase();
  final res = await localDb.rawQuery('''SELECT item_code, item_name, 
                                SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                FROM task_item
                                WHERE doc_no = '${docNo.trim()}' 
                                AND doc_type = '${docType.trim()}' 
                                GROUP BY item_code
                                ORDER BY (qty_required / qty_collected)
                                LIMIT $taskItemsFetchLimit;''');

  return getTaskItemsFromData(res);
}

Future<List<TaskItem>> getTaskItemsWithOffset(
  String docType,
  String docNo,
  int offset,
) async {
  Database localDb = await getDatabase();
  final res = await localDb.rawQuery('''SELECT item_code, item_name,
                                SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                FROM task_item
                                WHERE doc_no = '${docNo.trim()}' 
                                AND doc_type = '${docType.trim()}'
                                GROUP BY item_code
                                ORDER BY (qty_required / qty_collected)
                                LIMIT $taskItemsFetchLimit
                                OFFSET $offset;''');

  return getTaskItemsFromData(res);
}

List<TaskItem> getTaskItemsFromData(List<Map<String, Object?>> data) {
  List<TaskItem> items = data.map((item) {
    return TaskItem(
      itemCode: item["item_code"] as String,
      itemName: item["item_name"] as String,
      qtyRequired: item["qty_required"] as int,
      qtyCollected: item["qty_collected"] as int,
    );
  }).toList();

  return items;
}
