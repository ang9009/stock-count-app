import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock_count/utils/object_classes.dart';

part 'scanner_data_providers.g.dart';

final binNumberProvider = StateProvider<String?>((ref) {
  return null;
});

@riverpod
class CurrentTask extends _$CurrentTask {
  @override
  Task? build() {
    return null;
  }

  void setTask(Task newTask) {
    state = Task(
      docNo: newTask.docNo,
      docType: newTask.docType,
      parentType: newTask.parentType,
      lastUpdated: newTask.lastUpdated,
      createdAt: newTask.createdAt,
      qtyCollected: newTask.qtyCollected,
      qtyRequired: newTask.qtyRequired,
    );
  }
}
