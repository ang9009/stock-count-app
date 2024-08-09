import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

const int tasksFetchLimit = 30;

String getDocTypeFiltersCondition(Set<String> docTypeFilters) {
  if (docTypeFilters.isEmpty) return "";

  String filters = "";
  for (var i = 0; i < docTypeFilters.length; i++) {
    String filter = docTypeFilters.elementAt(i);
    if (i < docTypeFilters.length - 1) {
      filters += "'$filter', ";
    } else {
      filters += "'$filter'";
    }
  }
  return "WHERE t.doc_type IN ($filters)";
}

Future<List<Task>> getTasks({
  required Set<String> docTypeFilters,
  required int offset,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final List<Map<String, Object?>> tasksData;

  final tasksQuery = '''SELECT * FROM task t
                        LEFT OUTER JOIN (SELECT doc_type AS ti_doc_type, doc_no AS ti_doc_no,
                        SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                        FROM task_item
                        GROUP BY doc_type, doc_no) AS ti
                        ON t.doc_no = ti.ti_doc_no
                        AND t.doc_type = ti.ti_doc_type
                        ${getDocTypeFiltersCondition(docTypeFilters)}
                        ORDER BY t.last_updated DESC, t.created_at 
                        LIMIT $tasksFetchLimit
                        OFFSET $offset''';

  try {
    tasksData = await localDb.rawQuery(tasksQuery);
  } catch (err) {
    return Future.error(err.toString());
  }

  return getListOfTasksFromTaskData(tasksData);
}

List<Task> getListOfTasksFromTaskData(List<Map<String, Object?>> tasksData) {
  List<Task> tasks = [];
  for (final taskData in tasksData) {
    String docNo = taskData["doc_no"].toString();
    String docType = taskData["doc_type"].toString();
    String parentType = taskData["parent_type"].toString();
    DateTime createdAt = DateTime.parse(taskData["created_at"].toString());
    DateTime? lastUpdated = taskData["last_updated"] != null
        ? DateTime.parse(taskData["last_updated"].toString())
        : null;

    // This is nullable, since quantity entry receipts don't have required amounts
    int? qtyRequired = taskData["qty_required"] == null
        ? null
        : taskData["qty_required"] as int;
    int qtyCollected = taskData["qty_collected"] == null
        ? 0
        : taskData["qty_collected"] as int;

    final task = Task(
      parentType: parentType,
      docNo: docNo,
      docType: docType,
      createdAt: createdAt,
      qtyRequired: qtyRequired,
      qtyCollected: qtyCollected,
      lastUpdated: lastUpdated,
    );

    tasks.add(task);
  }

  return tasks;
}
