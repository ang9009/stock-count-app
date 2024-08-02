import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';

const int tasksFetchLimit = 20;

String getCompletionFilterCondition(TaskCompletionFilters completionFilter) {
  return switch (completionFilter) {
    TaskCompletionFilters.inProgress => "ti.qty_collected < ti.qty_required",
    TaskCompletionFilters.completed => "ti.qty_collected >= ti.qty_required",
  };
}

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
  return "AND t.doc_type IN ($filters)";
}

Future<List<Task>> getTasks({
  required TaskCompletionFilters completionFilter,
  required Set<String> docTypeFilters,
  int? offset,
}) async {
  Database localDb = await LocalDbHelper.instance.database;
  final tasksData = await localDb.rawQuery('''SELECT * FROM task t
                                              JOIN (SELECT doc_type, doc_no, 
                                              SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                              FROM task_item
                                              GROUP BY doc_type, doc_no) AS ti
                                              ON t.doc_no = ti.doc_no
                                              AND t.doc_type = ti.doc_type
                                              WHERE ${getCompletionFilterCondition(completionFilter)}
                                              ${getDocTypeFiltersCondition(docTypeFilters)}
                                              ORDER BY t.created_at, t.last_updated
                                              LIMIT $tasksFetchLimit
                                              ${offset != null ? "OFFSET $offset" : ""}''');

  return getListOfTasksFromTaskData(tasksData);
}

List<Task> getListOfTasksFromTaskData(List<Map<String, Object?>> tasksData) {
  List<Task> tasks = [];
  for (final taskData in tasksData) {
    String docNo = taskData["doc_no"].toString();
    String docType = taskData["doc_type"].toString();
    DateTime createdAt = DateTime.parse(taskData["created_at"].toString());
    DateTime? lastUpdated = taskData["last_updated"] != null
        ? DateTime.parse(taskData["last_updated"].toString())
        : null;
    int qtyRequired = taskData["qty_required"]! as int;

    final task = Task(
      docNo: docNo,
      docType: docType,
      createdAt: createdAt,
      qtyRequired: qtyRequired,
      lastUpdated: lastUpdated,
    );

    tasks.add(task);
  }

  return tasks;
}
