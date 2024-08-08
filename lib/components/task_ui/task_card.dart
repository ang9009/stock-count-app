import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/custom_checkbox.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/task_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
import 'package:stock_count/utils/object_classes.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelecting = ref.watch(tasksListIsSelecting);
    final selectedTasks = ref.watch(selectedTasksProvider);
    final currTaskProvider = ref.watch(currentTaskProvider);

    return GestureDetector(
      onTap: () {
        onTap(
          isSelecting,
          context,
          ref,
        );
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        ref.read(tasksListIsSelecting.notifier).state = true;
        ref.read(selectedTasksProvider.notifier).addSelectedTask(task);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        child: Padding(
          padding: WidgetSizes.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isSelecting) ...[
                CustomCheckbox(
                  isChecked: selectedTasks.contains(task),
                ),
                SizedBox(
                  width: WidgetSizes.cardCheckboxMargin,
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        task.docNo,
                        style: TextStyles.heading,
                      ),
                      SizedBox(width: 12.sp),
                      Row(
                        children: [
                          SvgPicture.asset(
                            height: 16.sp,
                            "assets/icons/document.svg",
                            colorFilter: const ColorFilter.mode(
                              AppColors.lighterTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            task.docType,
                            style: TextStyles.subHeading,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.lastUpdated != null
                        ? "Last updated ${DateFormat('dd/MM/yyyy').format(task.lastUpdated!)}"
                        : "Created at ${DateFormat('dd/MM/yyyy').format(task.createdAt)}",
                    style: TextStyles.subHeading,
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      task.qtyRequired != null
                          ? "${((task.qtyCollected / task.qtyRequired!) * 100).round()}%"
                          : task.qtyCollected.toString(),
                      style: TextStyle(
                        fontSize: TextStyles.subHeading.fontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: Adaptive.w(13),
                      height: Adaptive.w(13),
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 8.sp,
                        value: task.qtyRequired != null
                            ? task.qtyCollected / task.qtyRequired!
                            : 1,
                        color: task.qtyRequired != null
                            ? AppColors.success
                            : AppColors.lighterTextColor,
                        backgroundColor: AppColors.progress,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onTap(
    bool isSelecting,
    BuildContext context,
    WidgetRef ref,
  ) {
    // Go to task page
    if (!isSelecting) {
      // Update current docNo and docType
      ref.read(currentTaskProvider.notifier).setTask(task);

      goToPageWithAnimation(
        context: context,
        page: TaskPage(
          docNo: task.docNo,
          docType: task.docType,
        ),
      );
      return;
    }

    // Select task logic
    final selectedTasksMethods = ref.read(selectedTasksProvider.notifier);
    final selectedTasks = ref.read(selectedTasksProvider);

    if (selectedTasks.contains(task)) {
      selectedTasksMethods.unselectTask(task);

      if (selectedTasks.length == 1) {
        ref.read(tasksListIsSelecting.notifier).state = false;
      }
    } else {
      selectedTasksMethods.addSelectedTask(task);
    }
  }
}
