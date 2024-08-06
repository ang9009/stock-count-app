import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_count/components/task_ui/item_details_floating_btns.dart';
import 'package:stock_count/components/task_ui/item_variant_card.dart';
import 'package:stock_count/components/task_ui/task_item_info.dart';
import 'package:stock_count/components/ui/infinite_scroll_list.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list_paging_controller.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/queries/get_item_variants.dart';
import 'package:stock_count/utils/queries/save_item_changes.dart';
import 'package:stock_count/utils/queries/update_last_updated.dart';

class ItemDetailsPage extends ConsumerStatefulWidget {
  final TaskItem taskItem;
  final String docNo;
  final String docType;
  final PagingController<int, TaskItem> taskItemsListController;

  const ItemDetailsPage({
    super.key,
    required this.taskItem,
    required this.docNo,
    required this.docType,
    required this.taskItemsListController,
  });

  @override
  ConsumerState<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends ConsumerState<ItemDetailsPage> {
  // Tracks changes made to item variants (qty collected, deletions). Only items that have been
  // changed are added to this map.
  // The int value is the updated qty collected. If an item needs to be deleted,
  // the qty collected is set to -1.
  final PagingController<int, ItemVariant> itemVariantsListController =
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
              clearItemChanges: clearItemChanges,
              itemVariantsPagingController: itemVariantsListController,
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
              listenable: itemVariantsListController,
              builder: (context, child) {
                return TaskItemInfo(
                  itemList: itemVariantsListController.itemList,
                  taskItem: widget.taskItem,
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
                pagingController: itemVariantsListController,
                itemBuilder: (item) => ItemVariantCard(
                  updateItemChanges: updateItemChanges,
                  pagingController: itemVariantsListController,
                  item: item,
                  docNo: widget.docNo,
                  docType: widget.docType,
                ),
                getItems: (pageKey) {
                  return getItemVariants(
                    itemCode: widget.taskItem.itemCode,
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
      widget.taskItemsListController.refresh();

      setState(() {
        itemChanges = {};
      });

      // Update the task's last_updated field
      await updateLastUpdated(
        docNo: widget.docNo,
        docType: widget.docType,
      );

      if (mounted) {
        const snackbar = SnackBar(
          content: Text("Changes saved"),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        TaskListPagingController.of(context).refresh();
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
