import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/components/ui/show_modal.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/providers/task_list_paging_controller.dart';
import 'package:stock_count/utils/helpers/show_snackbar.dart';
import 'package:stock_count/utils/queries/delete_tasks.dart';

class TaskActions extends ConsumerStatefulWidget {
  const TaskActions({
    super.key,
  });

  @override
  ConsumerState<TaskActions> createState() => _TaskActionsState();
}

class _TaskActionsState extends ConsumerState<TaskActions> {
  final OverlayPortalController selectionOptionsOverlayController =
      OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    final selectedTasks = ref.watch(selectedTasksProvider);
    ref.listen(tasksListIsSelecting, (_, isSelecting) {
      if (isSelecting) {
        selectionOptionsOverlayController.show();
      } else {
        selectionOptionsOverlayController.hide();
      }
    });

    return OverlayPortal(
      controller: selectionOptionsOverlayController,
      overlayChildBuilder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: WidgetSizes.bottomNavHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionChip(
                    elevation: 0,
                    color: const MaterialStatePropertyAll(
                      Colors.white,
                    ),
                    side: const BorderSide(
                      color: AppColors.borderColor,
                    ),
                    onPressed: () {},
                    padding: WidgetSizes.overlayOptionButtonPadding,
                    label: Text(
                      "Upload",
                      style: TextStyle(
                        color: AppColors.progress,
                        fontSize: AppTextStyles.heading.fontSize,
                      ),
                    ),
                  ),
                  Text(
                    "${selectedTasks.length} selected",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: AppTextStyles.heading.fontSize,
                    ),
                  ),
                  ActionChip(
                    elevation: 0,
                    color: const MaterialStatePropertyAll(
                      Colors.white,
                    ),
                    side: const BorderSide(
                      color: AppColors.borderColor,
                    ),
                    onPressed: () {
                      showDeleteConfirmationModal(context);
                    },
                    padding: WidgetSizes.overlayOptionButtonPadding,
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: AppTextStyles.heading.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteConfirmationModal(BuildContext context) {
    showModal(
      context: context,
      title: "Are you sure?",
      content: Column(
        children: [
          Text(
            "All selected tasks will be permanently deleted.",
            style: TextStyle(
              fontSize: AppTextStyles.heading.fontSize,
            ),
          ),
          SizedBox(height: 20.sp),
          Row(
            children: [
              Expanded(
                child: RoundedButton(
                  style: RoundedButtonStyles.outlined,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: "Cancel",
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: RoundedButton(
                  style: RoundedButtonStyles.solid,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final tasks = ref.read(selectedTasksProvider);
                    final listSize = tasks.length;
                    try {
                      await deleteTasks(tasks.toList());
                    } catch (err) {
                      if (context.mounted) {
                        showErrorSnackbar(context, err.toString());
                      }
                      return;
                    }

                    if (context.mounted) {
                      showSnackbar(
                        "Successfuly deleted $listSize task(s)",
                        context,
                      );
                      // Refresh task list to show changes
                      TaskListPagingController.of(context).refresh();
                      // Set is selecting to false, clear selected list
                      ref.read(tasksListIsSelecting.notifier).state = false;
                      ref.read(selectedTasksProvider).clear();
                    }
                  },
                  label: "Confirm",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
