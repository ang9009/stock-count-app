import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/utils/classes.dart';

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
            side: BorderSide.none,
            color: const MaterialStatePropertyAll(
              AppColors.borderColor,
            ),
            avatar: SvgPicture.asset(
              height: 15.sp,
              "icons/select_all.svg",
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            labelPadding: WidgetSizes.actionChipLabelPadding,
            label: selectedTasks.length != widget.tasks!.length
                ? const Text("Select all")
                : const Text("Unselect all"),
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            onPressed: () {
              final selectionMethods = ref.read(selectedTasksProvider.notifier);

              if (selectedTasks.length != widget.tasks!.length) {
                selectionMethods.selectAllTasks(widget.tasks!);
              } else {
                selectionMethods.clearSelectedTasks();
              }
            },
          ),
          ActionChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
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
