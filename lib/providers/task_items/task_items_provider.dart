import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_task_items.dart';

part 'task_items_provider.g.dart';

@riverpod
class TaskItems extends _$TaskItems {
  @override
  Future<List<TaskItem>> build({
    required String docType,
    required String docNo,
  }) async {
    return await getTaskItems(docType, docNo);
  }

  Future<List<TaskItem>> getMoreTaskItems({
    required String docType,
    required String docNo,
    required int offset,
  }) async {
    final currState = await future;
    final addedItems = await getTaskItemsWithOffset(
      docType,
      docNo,
      offset,
    );

    state = AsyncValue.data([...currState, ...addedItems]);
    return addedItems;
  }
}

void invalidateTaskItemsState(WidgetRef ref) {
  ref.invalidate(taskItemsProvider);
}
