import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/task_ui/item_details_floating_btns.dart';
import 'package:stock_count/components/task_ui/item_variant_card.dart';
import 'package:stock_count/components/task_ui/task_item_info.dart';
import 'package:stock_count/components/ui/error_snackbar.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/queries/get_item_variants.dart';
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

  final PagingController<int, ItemVariant> listPagingController =
      PagingController(firstPageKey: 0);
  Map<ItemVariant, int> itemChanges = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item details",
          style: TextStyles.largeTitle,
        ),
      ),
      floatingActionButton: itemChanges.isNotEmpty
          ? ItemDetailsFloatingBtns(
              pagingController: listPagingController,
              clearItemChanges: clearItemChanges,
              saveItemChanges: () => saveItemChangesAndUpdateUI(),
            )
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListenableBuilder(
              listenable: listPagingController,
              builder: (context, child) {
                return TaskItemInfo(
                  itemName: widget.itemName,
                  itemCode: widget.itemCode,
                  docNo: widget.docNo,
                  docType: widget.docType,
                );
              },
            ),
            SizedBox(height: 30.sp),
            Text(
              "Item variants collected",
              style: TextStyles.heading,
            ),
            SizedBox(height: 16.sp),
            Expanded(
              child: InfiniteScrollList<ItemVariant>(
                pagingController: listPagingController,
                itemBuilder: (item) => ItemVariantCard(
                  updateItemChanges: updateItemChanges,
                  pagingController: listPagingController,
                  item: item,
                  docNo: widget.docNo,
                  docType: widget.docType,
                ),
                loadingAnimation: const ReceiptListLoadingAnimation(),
                getItems: (pageKey) {
                  return getItemVariants(
                    itemCode: widget.itemCode,
                    docNo: widget.docNo,
                    docType: widget.docType,
                    offset: pageKey,
                  );
                },
                fetchLimit: itemVariantsFetchLimit,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

      if (mounted) {
        const snackbar = SnackBar(
          content: Text("Changes saved"),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (err) {
      if (mounted) {
        showErrorSnackbar(
          context,
          "An error occurred while saving changes: ${err.toString()}",
        );
      }
      debugPrint(err.toString());
    }
  }
}

class ReceiptListLoadingAnimation extends StatelessWidget {
  const ReceiptListLoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dummyItem = ItemVariant(
      itemBarcode: "123123132",
      lotNo: "123123123123",
      binNo: "B03",
      itemCode: "123123123",
      qtyCollected: 21,
      barcodeValueType: BarcodeValueTypes.barcode,
    );
    final skeleton = Skeletonizer(
      child: ItemVariantCard(
        pagingController: PagingController(firstPageKey: 0),
        updateItemChanges: ({
          required ItemVariant item,
          required int updatedQtyCollected,
        }) {
          return "";
        },
        docNo: "12312300",
        docType: "DN",
        item: dummyItem,
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          skeleton,
          SizedBox(height: 12.sp),
          skeleton,
          SizedBox(height: 12.sp),
          skeleton,
          SizedBox(height: 12.sp),
        ],
      ),
    );
  }
}
