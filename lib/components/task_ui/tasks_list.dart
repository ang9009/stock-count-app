import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/task_ui/task_card.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_tasks.dart';

class TasksList extends ConsumerStatefulWidget {
  final PagingController<int, Task> pagingController;

  const TasksList({
    required this.pagingController,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TasksList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    Set<String> docTypeFilters = ref.read(selectedTaskFiltersProvider);
    final completionFilter = ref.read(taskCompletionFilter);

    try {
      final newTasks = await getTasks(
        docTypeFilters: docTypeFilters,
        completionFilter: completionFilter,
        offset: pageKey,
      );

      final isLastPage = newTasks.length < tasksFetchLimit;
      if (isLastPage) {
        widget.pagingController.appendLastPage(newTasks);
      } else {
        int newPageKey = pageKey + tasksFetchLimit;
        widget.pagingController.appendPage(newTasks, newPageKey);
      }
    } catch (err) {
      widget.pagingController.error = err;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(taskCompletionFilter, (previous, next) {
      widget.pagingController.refresh();
    });
    ref.listen(selectedTaskFiltersProvider, (previous, next) {
      widget.pagingController.refresh();
    });

    return Expanded(
      child: PagedListView.separated(
        pagingController: widget.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Task>(
          itemBuilder: (context, item, index) => TaskCard(task: item),
          firstPageProgressIndicatorBuilder: (context) {
            return const TasksListLoadingAnimation();
          },
        ),
        separatorBuilder: (context, index) => SizedBox(height: 12.sp),
      ),
    );
  }
}

class TasksListLoadingAnimation extends StatelessWidget {
  const TasksListLoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime(1),
              qtyRequired: 2,
              lastUpdated: DateTime(1),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime(1),
              qtyRequired: 2,
              lastUpdated: DateTime(1),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime(1),
              qtyRequired: 2,
              lastUpdated: DateTime(1),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime(1),
              qtyRequired: 2,
              lastUpdated: DateTime(1),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime(1),
              qtyRequired: 2,
              lastUpdated: DateTime(1),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime(1),
              qtyRequired: 2,
              lastUpdated: DateTime(1),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Skeletonizer(
          child: TaskCard(
            task: Task(
              docNo: "SCR-123123ASDASD",
              docType: "GR3",
              createdAt: DateTime.now(),
              qtyRequired: 2,
              lastUpdated: DateTime.now(),
            ),
          ),
        ),
      ],
    );
  }
}
