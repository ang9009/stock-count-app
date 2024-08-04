import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/task_ui/item_details_floating_btns.dart';
import 'package:stock_count/components/task_ui/task_item_info.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/item_variants/item_variants_provider.dart';
import 'package:stock_count/providers/task_items/task_items_provider.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/queries/save_item_changes.dart';

class ItemDetailsPage extends ConsumerStatefulWidget {
  final String itemName;
  final String itemCode;
  final String docNo;
  final String docType;

  const ItemDetailsPage({
    super.key,
    required this.itemCode,
    required this.itemName,
    required this.docNo,
    required this.docType,
  });

  @override
  ConsumerState<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class ItemVariantIdData {}

class _ItemDetailsPageState extends ConsumerState<ItemDetailsPage> {
  // Tracks changes made to item variants (qty collected, deletions). Only items that have been
  // changed are added to this map.
  // The int value is the updated qty collected. If an item needs to be deleted,
  // the qty collected is set to -1.
  Map<ItemVariant, int> itemChanges = {};

  void updateItemChanges({
    required ItemVariant item,
    required int updatedQtyCollected,
  }) {
    if (updatedQtyCollected == 0 || updatedQtyCollected < -1) {
      throw ErrorDescription(
        "Tried to set qtyCollected in itemChanges to an invalid qty $updatedQtyCollected",
      );
    }

    setState(() {
      itemChanges[item] = updatedQtyCollected;
    });
  }

  void clearItemChanges() {
    setState(() {
      itemChanges = {};
    });
  }

  void saveItemChangesAndUpdateUI() async {
    try {
      await saveItemChanges(
        itemChanges,
        widget.docNo,
        widget.docType,
      );

      setState(() {
        itemChanges = {};
      });
      invalidateItemVariantsAndTaskItems();

      if (mounted) {
        const snackbar = SnackBar(
          content: Text("Changes saved"),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (err) {
      if (mounted) {
        final error = SnackBar(
          content:
              Text("An error occurred while saving changes: ${err.toString()}"),
        );
        ScaffoldMessenger.of(context).showSnackBar(error);
      }
      debugPrint(err.toString());
    }
  }

  void invalidateItemVariantsAndTaskItems() {
    ref.invalidate(itemVariantsProvider(
      docNo: widget.docNo,
      docType: widget.docType,
      itemCode: widget.itemCode,
    ));
    ref.invalidate(taskItemsProvider(
      docNo: widget.docNo,
      docType: widget.docType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final itemsProvider = itemVariantsProvider(
      docNo: widget.docNo,
      docType: widget.docType,
      itemCode: widget.itemCode,
    );
    final itemVariants = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item details",
          style: TextStyles.largeTitle,
        ),
      ),
      floatingActionButton: itemChanges.isNotEmpty
          ? ItemDetailsFloatingBtns(
              clearItemChanges: clearItemChanges,
              itemsProvider: itemsProvider,
              saveItemChanges: () => saveItemChangesAndUpdateUI(),
            )
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskItemInfo(
              itemName: widget.itemName,
              itemCode: widget.itemCode,
              docNo: widget.docNo,
              docType: widget.docType,
            ),
            SizedBox(height: 30.sp),
            Text(
              "Item variants collected",
              style: TextStyles.heading,
            ),
            SizedBox(height: 16.sp),
            // InfiniteScrollList(
            //   bottomPadding: itemChanges.isEmpty ? 0.sp : 33.sp,
            //   pendingListData: itemVariants,
            //   fetchLimit: itemVariantsFetchLimit,
            //   separator: SizedBox(height: 15.sp),
            //   getCurrItemCard: (itemVariant) {
            //     return ItemVariantCard(
            //       item: itemVariant,
            //       docNo: widget.docNo,
            //       docType: widget.docType,
            //       updateItemChanges: updateItemChanges,
            //     );
            //   },
            //   getMoreItems: ({required int offset}) {
            //     final itemVariantMethods = ref.read(
            //       itemVariantsProvider(
            //         docNo: widget.docNo,
            //         docType: widget.docType,
            //         itemCode: widget.itemCode,
            //       ).notifier,
            //     );

            //     return itemVariantMethods.getMoreItemVariants(
            //       docType: widget.docType,
            //       docNo: widget.docNo,
            //       offset: offset,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
