import 'package:flutter/material.dart';
import 'package:stock_count/components/scanning/bottom_drawer.dart';
import 'package:stock_count/components/ui/labelled_checkbox.dart';
import 'package:stock_count/utils/classes.dart';

class ReceiptFilterModal extends StatelessWidget {
  final List<ReceiptDocTypeFilterOption> docTypes;
  final ReceiptDocTypeFilterOption selectedOption;
  final Function(ReceiptDocTypeFilterOption selectedOption) onTap;

  const ReceiptFilterModal({
    super.key,
    required this.docTypes,
    required this.selectedOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      title: "Filter by",
      contents: SizedBox(
        width: double.infinity,
        height: 24 * 6 + 25 * 5,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final currDocType = docTypes[index];
            bool isSelected = currDocType == selectedOption;

            return LabelledCheckbox(
              label: currDocType.docDesc,
              value: isSelected,
              onTap: () {
                onTap(currDocType);
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
