import 'package:flutter/material.dart';
import 'package:stock_count/components/create_task/add_task_option.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/look_for_receipt_online_page.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add task",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select receipt entry method",
                style: TextStyles.largeTitle,
              ),
              const SizedBox(
                height: 12,
              ),
              AddTaskOption(
                label: "Look for receipt online",
                icon: "assets/icons/globe.svg",
                onTap: () {
                  goToRoute(
                    context: context,
                    page: const LookForReceiptOnlinePage(),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              AddTaskOption(
                label: "Enter receipt details manually",
                icon: "assets/icons/edit.svg",
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
