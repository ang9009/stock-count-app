import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/initialize_db.dart';

const int tasksFetchLimit = 20;

String getDocTypeFilterCondition(String? docTypeFilter) {
  return switch (docTypeFilter) {
    null => "",
    _ => "AND t.doc_type = '${docTypeFilter.toUpperCase().trim()}'",
  };
}

String getCompletionFilterCondition(TaskCompletionFilters completionFilter) {
  return switch (completionFilter) {
    TaskCompletionFilters.inProgress => "ti.qty_collected < ti.qty_required",
    TaskCompletionFilters.completed => "ti.qty_collected >= ti.qty_required",
  };
}

Future<List<Task>> getTasks({
  required TaskCompletionFilters completionFilter,
  required String? docTypeFilter,
}) async {
  Database localDb = await getDatabase();
  final tasksData = await localDb.rawQuery('''SELECT * FROM task t
                                              JOIN (SELECT doc_type, doc_no, 
                                              SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                              FROM task_item
                                              GROUP BY doc_type, doc_no) AS ti
                                              ON t.doc_no = ti.doc_no
                                              AND t.doc_type = ti.doc_type
                                              WHERE ${getCompletionFilterCondition(completionFilter)}
                                              ${getDocTypeFilterCondition(docTypeFilter)}
                                              ORDER BY t.created_at, t.last_updated
                                              LIMIT $tasksFetchLimit;''');

  return getListOfTasksFromTaskData(tasksData);
}

Future<List<Task>> getTasksWithOffset({
  required TaskCompletionFilters completionFilter,
  required String? docTypeFilter,
  required int offset,
}) async {
  log(offset.toString());
  Database localDb = await getDatabase();
  final tasksData = await localDb.rawQuery('''SELECT * FROM task t
                                              JOIN (SELECT doc_type, doc_no, 
                                              SUM(qty_required) AS qty_required, SUM(qty_collected) AS qty_collected
                                              FROM task_item
                                              GROUP BY doc_type, doc_no) AS ti
                                              ON t.doc_no = ti.doc_no
                                              AND t.doc_type = ti.doc_type
                                              WHERE ${getCompletionFilterCondition(completionFilter)}
                                              ${getDocTypeFilterCondition(docTypeFilter)}
                                              ORDER BY t.created_at, t.last_updated
                                              LIMIT $tasksFetchLimit
                                              OFFSET $offset;''');

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
