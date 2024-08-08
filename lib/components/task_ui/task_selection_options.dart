import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/utils/object_classes.dart';

class TaskSelectionOptions extends ConsumerStatefulWidget {
  final List<Task>? tasks;

  const TaskSelectionOptions({
    super.key,
    required this.tasks,
  });

  @override
  ConsumerState<TaskSelectionOptions> createState() =>
      _TaskSelectionOptionsState();
}

class _TaskSelectionOptionsState extends ConsumerState<TaskSelectionOptions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTasks = ref.watch(selectedTasksProvider);

    if (widget.tasks != null) {
      return Row(
        children: [
          ActionChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(
              color: AppColors.borderColor,
            ),
            color: const MaterialStatePropertyAll(Colors.transparent),
            label: const Text("Cancel"),
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            onPressed: () {
              ref.watch(tasksListIsSelecting.notifier).state = false;
              ref.watch(selectedTasksProvider.notifier).clearSelectedTasks();
            },
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
