import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_count/components/bottom_drawer.dart';
import 'package:stock_count/components/labelled_checkbox.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';

class ReceiptFilterModal extends ConsumerWidget {
  final List<ReceiptDocTypeFilterOption> docTypes;

  const ReceiptFilterModal({
    super.key,
    required this.docTypes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilterOption = ref.watch(
      selectedReceiptTypeProvider(docTypes),
    );

    return BottomDrawer(
      title: "Filter by",
      contents: SizedBox(
        width: double.infinity,
        height: 24 * 6 + 25 * 5,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final currDocType = docTypes[index];
            bool isSelected = currDocType == selectedFilterOption;

            return LabelledCheckbox(
              label: currDocType.docDesc,
              value: isSelected,
              onTap: () {
                ref
                    .read(selectedReceiptTypeProvider(docTypes).notifier)
                    .setSelectedType(selectedFilterOption);
                log(currDocType.docDesc);
                ref
                    .read(selectedReceiptsProvider.notifier)
                    .clearSelectedReceipts();
              },
            );
          },
          itemCount: docTypes.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 25);
          },
        ),
      ),
    );
  }
}
