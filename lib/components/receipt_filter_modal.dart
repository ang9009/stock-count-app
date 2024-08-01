import 'package:flutter/material.dart';
import 'package:stock_count/components/bottom_drawer.dart';
import 'package:stock_count/components/labelled_checkbox.dart';

class ReceiptFilterModal extends StatelessWidget {
  final List<dynamic> documentTypes;
  final ({String docDesc, String parentType}) selectedModalFilterOption;
  final Function(({String docDesc, String parentType})) onOptionSelected;

  const ReceiptFilterModal({
    super.key,
    required this.documentTypes,
    required this.onOptionSelected,
    required this.selectedModalFilterOption,
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
            final String currFilterOption = documentTypes[index]["doc_desc"]!;
            final String parentType =
                documentTypes[index]["parent_type"]!.toString().toLowerCase();
            final ({String docDesc, String parentType}) optionData =
                (docDesc: currFilterOption, parentType: parentType);

            return LabelledCheckbox(
              label: currFilterOption,
              value: optionData == selectedModalFilterOption,
              onChanged: () {
                onOptionSelected(optionData);
              },
            );
          },
          itemCount: documentTypes.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 25);
          },
        ),
      ),
    );
  }
}
