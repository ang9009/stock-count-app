import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_provider.dart';
import 'package:stock_count/utils/enums.dart';

class TasksPageFilters extends ConsumerWidget {
  final filterOptions = const ["In progress", "Completed"];

  const TasksPageFilters({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(taskCompletionFilter);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(taskCompletionFilter.notifier).state =
                TaskCompletionFilters.inProgress;
          },
          child: Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: const Text("In progress"),
            backgroundColor: selectedFilter == TaskCompletionFilters.inProgress
                ? Colors.black
                : Colors.white,
            labelStyle: TextStyle(
              color: selectedFilter == TaskCompletionFilters.inProgress
                  ? Colors.white
                  : Colors.black,
            ),
            side: BorderSide(
              color: selectedFilter == TaskCompletionFilters.inProgress
                  ? Colors.transparent
                  : AppColors.borderColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            ref.read(taskCompletionFilter.notifier).state =
                TaskCompletionFilters.completed;
          },
          child: Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: const Text("Completed"),
            backgroundColor: selectedFilter == TaskCompletionFilters.completed
                ? Colors.black
                : Colors.white,
            labelStyle: TextStyle(
              color: selectedFilter == TaskCompletionFilters.completed
                  ? Colors.white
                  : Colors.black,
            ),
            side: BorderSide(
              color: selectedFilter == TaskCompletionFilters.completed
                  ? Colors.transparent
                  : AppColors.borderColor,
            ),
          ),
        ),
      ],
    );
  }
}
