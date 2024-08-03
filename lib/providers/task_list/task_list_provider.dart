import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/queries/get_downloaded_doc_types.dart';
import 'package:stock_count/utils/queries/get_tasks.dart';

part 'task_list_provider.g.dart';

final taskCompletionFilter =
    StateProvider((_) => TaskCompletionFilters.inProgress);

final tasksListIsSelecting = StateProvider((_) => false);

@riverpod
class SelectedTasks extends _$SelectedTasks {
  @override
  Set<Task> build() {
    return {};
  }

  void selectAllTasks() {
    final allTasks = ref.read(tasksProvider);

    if (allTasks.hasValue) {
      state = {...allTasks.requireValue};
    }
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

  void replaceFilters(Set<String> filters) {
    state = filters;
  }
}

@riverpod
class Tasks extends _$Tasks {
  @override
  Future<List<Task>> build() async {
    Set<String> docTypeFilters = ref.watch(selectedTaskFiltersProvider);
    final completionFilter = ref.watch(taskCompletionFilter);

    return getTasks(
      docTypeFilters: docTypeFilters,
      completionFilter: completionFilter,
    );
  }

  Future<List<Task>> getMoreTasks(int offset) async {
    Set<String> docTypeFilters = ref.watch(selectedTaskFiltersProvider);
    final completionFilter = ref.watch(taskCompletionFilter);

    log(offset.toString());

    final moreTasks = await getTasks(
      completionFilter: completionFilter,
      docTypeFilters: docTypeFilters,
      offset: offset,
    );
    final currState = await future;
    state = AsyncValue.data([...currState, ...moreTasks]);

    return moreTasks;
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
  ref.invalidate(tasksProvider);
  ref.invalidate(docTypeFilterOptionsProvider);
}