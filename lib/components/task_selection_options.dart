import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_provider.dart';

class TaskSelectionOptions extends ConsumerWidget {
  const TaskSelectionOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTasks = ref.watch(selectedTasksProvider);
    final tasks = ref.watch(tasksProvider);

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
          label: selectedTasks.length != tasks.requireValue.length
              ? const Text("Select all")
              : const Text("Unselect all"),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          onPressed: () {
            final selectionMethods = ref.read(selectedTasksProvider.notifier);

            if (selectedTasks.length != tasks.requireValue.length) {
              selectionMethods.selectAllTasks();
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
  }
}
