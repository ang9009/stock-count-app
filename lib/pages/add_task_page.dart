import 'package:flutter/material.dart';
import 'package:stock_count/components/create_task/add_task_option.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/data_required_receipts_page.dart';
import 'package:stock_count/pages/quantity_entry_receipts_page.dart';
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
                "Select receipt type",
                style: TextStyles.largeTitle,
              ),
              const SizedBox(
                height: 12,
              ),
              AddTaskOption(
                label: "Data-required receipts",
                icon: "assets/icons/globe.svg",
                onTap: () {
                  goToPageWithAnimation(
                    context: context,
                    page: const DataRequiredReceiptsPage(),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              AddTaskOption(
                label: "Quantity entry receipts",
                icon: "assets/icons/edit.svg",
                onTap: () {
                  goToPageWithAnimation(
                    context: context,
                    page: const QuantityEntryReceiptsPage(),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
