import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/utils/helpers/get_item_variant_card_label_data.dart';
import 'package:stock_count/utils/object_classes.dart';

class ItemVariantCard extends ConsumerStatefulWidget {
  final ItemVariant item;
  final String docNo;
  final String docType;
  final PagingController<int, ItemVariant> pagingController;

  final Function({
    required ItemVariant item,
    required int updatedQtyCollected,
  }) updateItemChanges;

  const ItemVariantCard({
    super.key,
    required this.pagingController,
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

  @override
  void initState() {
    _qtyFieldController = TextEditingController(
      text: widget.item.qtyCollected.toString(),
    );

    _qtyInputFocusNode.addListener(() {
      qtyInputFocusCallback();
    });

    cardLabelData = getItemVariantCardLabelData(widget.item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This is necessary for rebuilds. When items are removed from the list, the value shown
    // must be updated correctly
    _qtyFieldController.text = widget.item.qtyCollected.toString();

    return Card(
      key: ValueKey(widget.item),
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
            if (widget.item.binNo != null)
              Text(
                "Bin number ${widget.item.binNo!}",
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
                          updateItemQtyCollected(
                            increment: true,
                          );
                        },
                  style: incrementButtonStyles,
                  child: SvgPicture.asset(
                    width: 16.sp,
                    "assets/icons/plus.svg",
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
                          updateItemQtyCollected(
                            increment: false,
                          );
                        },
                  style: incrementButtonStyles,
                  child: SvgPicture.asset(
                    width: 16.sp,
                    "assets/icons/minus.svg",
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
                    "assets/icons/trash.svg",
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

  bool itemListExists() {
    final items = widget.pagingController.itemList;
    if (items == null) {
      showErrorSnackbar(
        context,
        "An unexpected error occurred: item variants are null",
      );
      return false;
    }

    return true;
  }

  void setItemQtyCollected({
    required int qty,
  }) {
    if (!itemListExists()) {
      return;
    }

    final items = widget.pagingController.itemList!;
    final updatedItem = ItemVariant(
      binNo: widget.item.binNo,
      itemCode: widget.item.itemCode,
      lotNo: widget.item.lotNo,
      itemBarcode: widget.item.itemBarcode,
      qtyCollected: qty,
      barcodeValueType: widget.item.barcodeValueType,
    );
    widget.pagingController.itemList = [
      for (final currItem in items)
        if (currItem == widget.item) updatedItem else currItem
    ];
    _qtyFieldController.text = qty.toString();
    widget.updateItemChanges(
      item: widget.item,
      updatedQtyCollected: qty,
    );
  }

  void updateItemQtyCollected({
    required bool increment,
  }) {
    int newQty = widget.item.qtyCollected + (increment ? 1 : -1);
    setItemQtyCollected(qty: newQty);
    // Update item changes map
    widget.updateItemChanges(
      item: widget.item,
      updatedQtyCollected: newQty,
    );
  }

  // Remove item and update total qty collected
  void removeItem() {
    if (!itemListExists()) {
      return;
    }

    var itemList = widget.pagingController.itemList!;
    widget.pagingController.itemList = itemList
        .where(
          (currItem) => currItem != widget.item,
        )
        .toList();

    // Setting the qtyCollected to -1 signifies that the item should be deleted
    widget.updateItemChanges(
      item: widget.item,
      updatedQtyCollected: -1,
    );
  }

  // For when the quantity input is manually edited
  void qtyInputFocusCallback() {
    if (_qtyInputFocusNode.hasFocus) return;

    // If the field is cleared, set to previous value
    if (_qtyFieldController.text.isEmpty) {
      _qtyFieldController.text = widget.item.qtyCollected.toString();
      return;
    }

    int updatedQtyCollected = int.parse(_qtyFieldController.text);
    setItemQtyCollected(qty: updatedQtyCollected);
    widget.updateItemChanges(
      item: widget.item,
      updatedQtyCollected: updatedQtyCollected,
    );
  }
}
