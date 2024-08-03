import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';

class ReceiptSelectionOptions extends ConsumerWidget {
  final List<ReceiptDownloadOption>? allReceipts;

  const ReceiptSelectionOptions({
    required this.allReceipts,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReceipts = ref.watch(selectedReceiptsProvider);
    final selectedReceiptsMethods = ref.read(selectedReceiptsProvider.notifier);
    final selectedType = ref.watch(selectedReceiptTypeProvider);

    void setIsSelecting(bool isSelecting) => ref
        .read(receiptsListIsSelectingProvider.notifier)
        .setIsSelecting(isSelecting);

    if (allReceipts != null && selectedType != null) {
      return Row(
        children: [
          ActionChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            avatar: SvgPicture.asset(
              height: 15,
              "icons/select_all.svg",
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            labelPadding: WidgetSizes.actionChipLabelPadding,
            label: selectedReceipts.length == allReceipts!.length
                ? const Text("Select none")
                : const Text("Select all"),
            backgroundColor: AppColors.borderColor,
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            side: const BorderSide(
              color: Colors.transparent,
            ),
            onPressed: () {
              if (selectedReceipts.length == allReceipts!.length) {
                selectedReceiptsMethods.clearSelectedReceipts();
              } else {
                selectedReceiptsMethods.selectAllReceipts(
                  selectedType.parentType,
                  allReceipts!,
                );
              }
            },
          ),
          ActionChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: const Text("Cancel"),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            side: const BorderSide(
              color: Colors.transparent,
            ),
            onPressed: () {
              selectedReceiptsMethods.clearSelectedReceipts();
              setIsSelecting(false);
            },
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
