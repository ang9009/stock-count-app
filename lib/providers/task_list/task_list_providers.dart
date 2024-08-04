import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/queries/get_downloaded_doc_types.dart';

part 'task_list_providers.g.dart';

final taskCompletionFilter =
    StateProvider((_) => TaskCompletionFilters.inProgress);

final tasksListIsSelecting = StateProvider((_) => false);

@riverpod
class SelectedTasks extends _$SelectedTasks {
  @override
  Set<Task> build() {
    return {};
  }

  void selectAllTasks(List<Task> tasks) {
    state = {...tasks};
  }

  void addSelectedTask(Task task) {
    state = {...state, task};
  }

  void unselectTask(Task task) {
    state = {
      for (final currTask in state)
        if (currTask != task) currTask
    };
  }

  void clearSelectedTasks() {
    state = {};
  }
}

@riverpod
class SelectedTaskFilters extends _$SelectedTaskFilters {
  @override
  Set<String> build() {
    return {};
  }

  void setFilters(Set<String> filters) {
    state = {...filters};
  }
}

@riverpod
class DocTypeFilterOptions extends _$DocTypeFilterOptions {
  @override
  Future<List<String>> build() async {
    return getDownloadedDocTypes();
  }
}

void invalidateTaskListStates(WidgetRef ref) {
  ref.invalidate(docTypeFilterOptionsProvider);
}
