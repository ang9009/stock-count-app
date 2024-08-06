import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/custom_checkbox.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/queries/download_receipts_then_home.dart';

class ReceiptCard extends ConsumerWidget {
  final ReceiptDownloadOption receipt;
  final String parentType;

  const ReceiptCard({
    super.key,
    required this.receipt,
    required this.parentType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void setIsSelecting(bool isSelecting) {
      ref
          .read(receiptsListIsSelectingProvider.notifier)
          .setIsSelecting(isSelecting);
    }

    final selectedReceipts = ref.watch(selectedReceiptsProvider);
    final selectedReceiptsMethods = ref.read(selectedReceiptsProvider.notifier);
    final isSelected = selectedReceipts.contains(receipt);
    final isSelecting = ref.watch(receiptsListIsSelectingProvider);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          selectedReceiptsMethods.unselectReceipt(receipt);

          if (selectedReceipts.length == 1) {
            setIsSelecting(false);
          }
        } else {
          selectedReceiptsMethods.addSelectedReceipt(receipt);
        }
      },
      onLongPress: () {
        setIsSelecting(true);
        HapticFeedback.mediumImpact();
        selectedReceiptsMethods.addSelectedReceipt(receipt);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        child: Padding(
          padding: WidgetSizes.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isSelecting) ...[
                CustomCheckbox(
                  isChecked: isSelected,
                ),
                SizedBox(
                  width: WidgetSizes.cardCheckboxMargin,
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        receipt.docNo,
                        style: TextStyles.heading,
                      ),
                      SizedBox(width: 12.sp),
                      Row(
                        children: [
                          SvgPicture.asset(
                            height: 16.sp,
                            "assets/icons/document.svg",
                            colorFilter: const ColorFilter.mode(
                              AppColors.lighterTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            receipt.docType.toUpperCase(),
                            style: TextStyles.subHeading,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Created on ${DateFormat('dd/MM/yyyy').format(receipt.creationDate)}",
                    style: TextStyles.subHeading,
                  ),
                ],
              ),
              const Spacer(),
              if (!isSelecting)
                InkWell(
                  onTap: () {
                    downloadReceiptsThenHome(
                      receipts: [receipt],
                      parentType: parentType,
                      context: context,
                      ref: ref,
                    );
                  },
                  borderRadius: BorderRadius.circular(9999),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      height: 18.sp,
                      "assets/icons/download.svg",
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
