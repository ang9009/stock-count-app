import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/add_task_page.dart';
import 'package:stock_count/pages/my_tasks_page.dart';
import 'package:stock_count/providers/current_page/current_page_provider.dart';

class HomePage extends ConsumerWidget {
  final List<Widget> pages = const [MyTasksPage(), AddTaskPage()];

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentPage = ref.watch(currentPageProvider);
    final labelFontSize = 14.sp;
    final iconSize = 22.sp;

    return Scaffold(
      body: IndexedStack(index: currentPage, children: pages),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: WidgetSizes.bottomNavHeight,
        child: BottomNavigationBar(
          onTap: (index) {
            ref.read(currentPageProvider.notifier).setCurrentPage(index);
          },
          currentIndex: currentPage,
          selectedItemColor: Colors.black,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: labelFontSize,
          unselectedFontSize: labelFontSize,
          selectedIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          unselectedIconTheme: const IconThemeData(
            color: AppColors.lighterTextColor,
          ),
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Icons.home,
                  size: iconSize,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "Add task",
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Icons.add_circle,
                  size: iconSize,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "Settings",
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.settings,
                  size: iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}