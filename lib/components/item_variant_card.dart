// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/item_variants/item_variants_provider.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/get_item_variant_card_label_data.dart';

class ItemVariantCard extends ConsumerStatefulWidget {
  final ItemVariant item;
  final String docNo;
  final String docType;
  final Function({
    required ItemVariant item,
    required int updatedQtyCollected,
  }) updateItemChanges;

  const ItemVariantCard({
    super.key,
    required this.updateItemChanges,
    required this.item,
    required this.docNo,
    required this.docType,
  });

  @override
  ConsumerState<ItemVariantCard> createState() => _ItemVariantCardState();
}

final incrementButtonStyles = ElevatedButton.styleFrom(
  splashFactory: NoSplash.splashFactory,
  shape: const CircleBorder(),
  backgroundColor: AppColors.borderColor,
  elevation: 0,
  minimumSize: Size.square(28.sp),
  padding: const EdgeInsets.all(0),
  disabledBackgroundColor: const Color.fromRGBO(230, 232, 239, 0.3),
);

class _ItemVariantCardState extends ConsumerState<ItemVariantCard> {
  late final TextEditingController _qtyFieldController;
  final FocusNode _qtyInputFocusNode = FocusNode();
  late final ({String barcodeVal, String barcodeValTypeLabel}) cardLabelData;

  // Remove item and update total qty collected
  void removeItem() {
    ref
        .read(
          ItemVariantsProvider(
            itemCode: widget.item.itemCode,
            docType: widget.docType,
            docNo: widget.docNo,
          ).notifier,
        )
        .removeItem(widget.item);
  }

  void qtyInputFocusCallback() {
    if (_qtyInputFocusNode.hasFocus) return;

    // If empty, set to previous value
    if (_qtyFieldController.text.isEmpty) {
      _qtyFieldController.text = widget.item.qtyCollected.toString();
      return;
    }

    final itemVariantsMethods = ref.read(itemVariantsProvider(
      docNo: widget.docNo,
      docType: widget.docType,
      itemCode: widget.item.itemCode,
    ).notifier);

    int updatedQtyCollected = int.parse(_qtyFieldController.text);
    itemVariantsMethods.setItemQtyCollected(
      item: widget.item,
      qty: updatedQtyCollected,
    );
    widget.updateItemChanges(
      item: widget.item,
      updatedQtyCollected: updatedQtyCollected,
    );
  }

  @override
  void initState() {
    _qtyFieldController =
        TextEditingController(text: widget.item.qtyCollected.toString());

    _qtyInputFocusNode.addListener(() {
      qtyInputFocusCallback();
    });

    cardLabelData = getItemVariantCardLabelData(widget.item);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemVariantsMethods = ref.read(itemVariantsProvider(
      docNo: widget.docNo,
      docType: widget.docType,
      itemCode: widget.item.itemCode,
    ).notifier);

    ref.listen(
        itemVariantsProvider(
          docNo: widget.docNo,
          docType: widget.docType,
          itemCode: widget.item.itemCode,
        ), (_, newItems) {
      final updatedItem =
          newItems.requireValue.firstWhere((item) => item == widget.item);
      _qtyFieldController.text = updatedItem.qtyCollected.toString();
    });

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(
          color: AppColors.borderColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.sp,
          vertical: 18.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${cardLabelData.barcodeVal} (${cardLabelData.barcodeValTypeLabel})",
              style: TextStyle(
                fontSize: TextStyles.heading.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 8.sp,
            ),
            Text(
              "Bin number ${widget.item.binNo}",
              style: TextStyle(
                color: AppColors.lighterTextColor,
                fontSize: TextStyles.heading.fontSize,
              ),
            ),
            SizedBox(
              height: 16.sp,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _qtyInputFocusNode.hasFocus
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          itemVariantsMethods.updateItemQtyCollected(
                            item: widget.item,
                            increment: true,
                          );
                          widget.updateItemChanges(
                            item: widget.item,
                            updatedQtyCollected: widget.item.qtyCollected + 1,
                          );
                        },
                  style: incrementButtonStyles,
                  child: SvgPicture.asset(
                    width: 16.sp,
                    "icons/plus.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 15.sp),
                SizedBox(
                  width: 40.sp,
                  height: 28.sp,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _qtyFieldController,
                    focusNode: _qtyInputFocusNode,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.sp),
                        borderSide: const BorderSide(
                          color: AppColors.borderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.sp),
                        borderSide: const BorderSide(
                          color: AppColors.lighterTextColor,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 15.sp),
                ElevatedButton(
                  // Disable button if qtyCollected is reduced below 1, or if text input is focused
                  onPressed: widget.item.qtyCollected <= 1 ||
                          _qtyInputFocusNode.hasFocus
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          itemVariantsMethods.updateItemQtyCollected(
                            item: widget.item,
                            increment: false,
                          );
                          widget.updateItemChanges(
                            item: widget.item,
                            updatedQtyCollected: widget.item.qtyCollected - 1,
                          );
                        },
                  style: incrementButtonStyles,
                  child: SvgPicture.asset(
                    width: 16.sp,
                    "icons/minus.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    removeItem();
                    widget.updateItemChanges(
                      item: widget.item,
                      updatedQtyCollected: -1,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    shape: const CircleBorder(
                      side: BorderSide(color: AppColors.borderColor),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size.square(28.sp),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: SvgPicture.asset(
                    width: 16.sp,
                    "icons/trash.svg",
                    colorFilter: const ColorFilter.mode(
                      AppColors.warning,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
