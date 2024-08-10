import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';

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
                    onPressed: () {},
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
}
