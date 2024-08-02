import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/task_actions.dart';
import 'package:stock_count/components/task_selection_options.dart';
import 'package:stock_count/components/tasks_page_doc_filter_button.dart';
import 'package:stock_count/components/tasks_page_filters.dart';
import 'package:stock_count/providers/task_list/task_list_provider.dart';

class MyTasksPage extends ConsumerStatefulWidget {
  const MyTasksPage({super.key});

  @override
  ConsumerState<MyTasksPage> createState() => MyTasksPageState();
}

class MyTasksPageState extends ConsumerState<MyTasksPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final tasksMethods = ref.watch(tasksProvider.notifier);
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
              const TaskSelectionOptions()
            else
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TasksPageFilters(),
                  TasksPageDocFilterButton(),
                ],
              ),
            SizedBox(height: 13.sp),
            // InfiniteScrollList(
            //   pendingListData: tasks,
            //   fetchLimit: tasksFetchLimit,
            //   getCurrItemCard: (item) {
            //     return TaskCard(task: item);
            //   },
            //   getMoreItems: ({required int offset}) {
            //     return tasksMethods.getMoreTasks(offset);
            //   },
            // ),
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
}
