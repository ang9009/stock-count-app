import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/splash_screen.dart';
import 'package:stock_count/providers/task_list_paging_controller.dart';
import 'package:stock_count/utils/object_classes.dart';

void main() async {
  final PagingController<int, Task> taskListPagingController =
      PagingController(firstPageKey: 0);

  runApp(
    ProviderScope(
      child: TaskListPagingController(
        notifier: taskListPagingController,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: PrimaryTheme().themeData,
          home: const Center(
            child: SplashScreen(),
          ),
        );
      },
    );
  }
}
