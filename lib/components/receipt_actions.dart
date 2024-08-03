import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/download_receipts_then_home.dart';

class ReceiptActions extends ConsumerStatefulWidget {
  final ReceiptDocTypeFilterOption selectedReceiptType;

  const ReceiptActions({
    required this.selectedReceiptType,
    super.key,
  });

  @override
  ConsumerState<ReceiptActions> createState() => _ReceiptActionsState();
}

class _ReceiptActionsState extends ConsumerState<ReceiptActions> {
  final OverlayPortalController selectionOptionsOverlayController =
      OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    final selectedReceipts = ref.watch(selectedReceiptsProvider);
    ref.listen(receiptsListIsSelectingProvider, (_, isSelecting) {
      if (isSelecting) {
        selectionOptionsOverlayController.show();
      } else {
        selectionOptionsOverlayController.hide();
      }
    });

    return OverlayPortal(
      controller: selectionOptionsOverlayController,
      overlayChildBuilder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: WidgetSizes.bottomNavHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionChip(
                    elevation: 0,
                    color: const MaterialStatePropertyAll(
                      Colors.white,
                    ),
                    side: const BorderSide(
                      color: AppColors.borderColor,
                    ),
                    onPressed: () {
                      ref
                          .read(receiptsListIsSelectingProvider.notifier)
                          .setIsSelecting(false);

                      ref
                          .read(selectedReceiptsProvider.notifier)
                          .clearSelectedReceipts();
                    },
                    padding: WidgetSizes.overlayOptionButtonPadding,
                    label: Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppColors.lighterTextColor,
                        fontSize: TextStyles.heading.fontSize,
                      ),
                    ),
                  ),
                  Text(
                    "${selectedReceipts.length} selected",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: TextStyles.heading.fontSize,
                    ),
                  ),
                  ActionChip(
                    elevation: 0,
                    color: const MaterialStatePropertyAll(
                      Colors.white,
                    ),
                    side: const BorderSide(
                      color: AppColors.borderColor,
                    ),
                    onPressed: () {
                      downloadReceiptsThenHome(
                        receipts: selectedReceipts.toList(),
                        parentType: widget.selectedReceiptType.parentType,
                        context: context,
                        ref: ref,
                      );
                    },
                    padding: WidgetSizes.overlayOptionButtonPadding,
                    label: Text(
                      "Download",
                      style: TextStyle(
                        color: AppColors.progress,
                        fontSize: TextStyles.heading.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}