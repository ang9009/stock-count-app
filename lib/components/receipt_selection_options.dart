import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';

class ReceiptSelectionOptions extends ConsumerWidget {
  final String currDocType;
  final List<ReceiptDownloadOption>? allReceipts;

  const ReceiptSelectionOptions({
    required this.currDocType,
    required this.allReceipts,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReceipts = ref.watch(selectedReceiptsProvider);
    final selectedReceiptsMethods = ref.read(selectedReceiptsProvider.notifier);
    void setIsSelecting(bool isSelecting) => ref
        .read(receiptsListIsSelectingProvider.notifier)
        .setIsSelecting(isSelecting);

    if (allReceipts != null) {
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
                  currDocType,
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
