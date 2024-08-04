import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/task_ui/task_actions.dart';
import 'package:stock_count/components/task_ui/task_card.dart';
import 'package:stock_count/components/task_ui/task_selection_options.dart';
import 'package:stock_count/components/task_ui/tasks_page_doc_filter_button.dart';
import 'package:stock_count/components/task_ui/tasks_page_filters.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/get_tasks.dart';

class MyTasksPage extends ConsumerStatefulWidget {
  const MyTasksPage({super.key});

  @override
  ConsumerState<MyTasksPage> createState() => MyTasksPageState();
}

class MyTasksPageState extends ConsumerState<MyTasksPage> {
  final PagingController<int, Task> listPagingController =
      PagingController(firstPageKey: 0);
  late final List<Task>? tasks;

  @override
  void initState() {
    super.initState();
    tasks = null;
  }

  @override
  Widget build(BuildContext context) {
    final isSelecting = ref.watch(tasksListIsSelecting);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My tasks",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if (isSelecting)
              ListenableBuilder(
                listenable: listPagingController,
                builder: (context, child) {
                  return TaskSelectionOptions(
                    tasks: listPagingController.itemList,
                  );
                },
              )
            else
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TasksPageFilters(),
                  TasksPageDocFilterButton(),
                ],
              ),
            SizedBox(height: 13.sp),
            InfiniteScrollList(
              fetchPage: _fetchPage,
              pagingController: listPagingController,
              itemBuilder: (item) {
                return TaskCard(task: item);
              },
              separatorBuilder: () => SizedBox(height: 12.sp),
              loadingAnimation: const TasksListLoadingAnimation(),
            ),
            // Only shows when isSelecting
            const TaskActions(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
        listPagingController.appendLastPage(newTasks);
      } else {
        int newPageKey = pageKey + tasksFetchLimit;
        listPagingController.appendPage(newTasks, newPageKey);
      }
    } catch (err) {
      listPagingController.error = err;
    }
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
