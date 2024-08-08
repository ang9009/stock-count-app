import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stock_count/utils/object_classes.dart';

// A global notifier that allows access to the task list paging controller
// Used to refresh the list whenever new data is saved/data is updated
class TaskListPagingController
    extends InheritedNotifier<PagingController<int, Task>> {
  const TaskListPagingController({
    super.key,
    required super.notifier,
    required super.child,
  });

  static PagingController<int, Task> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskListPagingController>()!
        .notifier!;
  }
}
