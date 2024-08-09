import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/scanning/barcode_scanner.dart';
import 'package:stock_count/components/scanning/bottom_drawer.dart';
import 'package:stock_count/components/scanning/scan_items_sheet_row_item.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/scan_bin_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/providers/settings/settings_provider.dart';
import 'package:stock_count/providers/task_list_paging_controller.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/get_doc_type_require_ref_no.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
import 'package:stock_count/utils/helpers/show_loading_overlay.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/queries/get_doc_type_allow_unknown.dart';
import 'package:stock_count/utils/queries/get_scanned_item_data.dart';
import 'package:stock_count/utils/queries/update_last_updated.dart';
import 'package:stock_count/utils/queries/update_scanned_item_quantity.dart';

class ScanItemsPage extends ConsumerStatefulWidget {
  final PagingController<int, TaskItem> taskItemsListController;

  const ScanItemsPage({
    super.key,
    required this.taskItemsListController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanItemPageState();
}

class _ScanItemPageState extends ConsumerState<ScanItemsPage> {
  bool preventScan = false;
  late Future<bool> pendingAllowUnknown;
  late Future<bool> pendingNeedRefNo;
  ScannedItem? currItem;

  @override
  void initState() {
    final currTask = ref.read(currentTaskProvider)!;
    pendingAllowUnknown = getDocTypeAllowUnknown(currTask.parentType);
    pendingNeedRefNo = getDocTypeNeedRefNo(currTask.parentType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final binNo = ref.watch(binNumberProvider);
    final settings = ref.watch(settingsProvider);

    return FutureBuilder(
      future: Future.wait([pendingAllowUnknown, pendingNeedRefNo]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool allowUnknown = snapshot.requireData[0];
          bool needRefNo = snapshot.requireData[1];

          return BarcodeScanner(
            preventScan: preventScan,
            appBarTitle: Text(
              "Scan items",
              style: TextStyle(
                fontSize: TextStyles.largeTitle.fontSize,
                color: Colors.white,
              ),
            ),
            onDetect: (BarcodeCapture capture) async {
              onBarcodeDetect(capture, allowUnknown, needRefNo);
            },
            stackContent: [
              switch (settings) {
                AsyncData(:final value) => value.enableBin == true
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: Adaptive.h(16),
                        child: CurrentBinWidget(
                          binNo: binNo,
                          taskItemsListController:
                              widget.taskItemsListController,
                        ),
                      )
                    : const SizedBox.shrink(),
                _ => const SizedBox.shrink()
              }
            ],
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "Error: ${snapshot.error.toString()}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void onBarcodeDetect(
    BarcodeCapture capture,
    bool allowUnknown,
    bool needRefNo,
  ) async {
    setState(() {
      preventScan = true;
    });

    String barcode = capture.barcodes.first.rawValue.toString();
    final currTask = ref.read(currentTaskProvider);

    if (currTask == null) {
      openErrorBottomSheet(
        "An unexpected exception occurred: current document data is null",
      );
    }

    showLoadingOverlay(context);
    await getScannedItemData(
      barcode: barcode,
      docType: currTask!.docType,
      docNo: currTask.docNo,
      allowUnknown: allowUnknown,
      needRefNo: needRefNo,
    ).then((item) {
      // Get rid of loading overlay
      Navigator.of(context).pop();
      setState(() {
        currItem = item;
        openItemDetailsSheet();
      });
    }).onError((error, stackTrace) {
      // Get rid of loading overlay
      Navigator.of(context).pop();
      openErrorBottomSheet(error.toString());
    });
  }

  void openErrorBottomSheet(String errMsg) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomDrawer(
          title: "An error occurred",
          contents: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                errMsg,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 16.sp,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 18.sp),
              RoundedButton(
                style: RoundedButtonStyles.solid,
                onPressed: () {
                  // Close modal
                  Navigator.of(context).pop();
                },
                label: "Okay",
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        preventScan = false;
      });
    });
  }

  void openItemDetailsSheet() {
    if (currItem == null) {
      setState(() {
        preventScan = true;
      });

      openErrorBottomSheet(
        "An unexpected exception occurred: current scanned item is null",
      );
      return;
    }
    final item = currItem!.taskItem;
    final itemBarcode = currItem!.barcode;
    final barcodeType = currItem!.barcodeValueType;
    final currParentType = ref.read(currentTaskProvider)!.docType;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomDrawer(
          title: "Item details",
          contents: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (barcodeType != BarcodeValueTypes.unknown)
                Column(
                  children: [
                    ScanItemsSheetRowItem(
                      label: "Name",
                      value: item.itemName == unknownItemName
                          ? "Unknown name"
                          : item.itemName,
                    ),
                    Divider(
                      color: AppColors.borderColor,
                      height: 24.sp,
                    ),
                    ScanItemsSheetRowItem(
                      label: "Item code",
                      value: item.itemCode,
                    ),
                    Divider(
                      color: AppColors.borderColor,
                      height: 24.sp,
                    ),
                  ],
                ),
              ScanItemsSheetRowItem(
                label: "Quantity collected",
                value: item.qtyRequired == null
                    ? item.qtyCollected.toString()
                    : "${item.qtyCollected.toString()} / ${item.qtyRequired.toString()}",
              ),
              Divider(
                color: AppColors.borderColor,
                height: 24.sp,
              ),
              ScanItemsSheetRowItem(
                label: "Barcode value",
                value: itemBarcode,
              ),
              Divider(
                color: AppColors.borderColor,
                height: 24.sp,
              ),
              if (barcodeType == BarcodeValueTypes.unknown)
                Column(
                  children: [
                    Text(
                      "Note: this item's data is unknown, but this receipt type \"$currParentType\" allows unknown items. Add anyway?",
                      style: TextStyle(
                        color: AppColors.lighterTextColor,
                        fontSize: 17.sp,
                      ),
                    ),
                    Divider(
                      color: AppColors.borderColor,
                      height: 24.sp,
                    ),
                  ],
                ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: RoundedButton(
                      style: RoundedButtonStyles.outlined,
                      onPressed: () {
                        // Close modal
                        Navigator.of(context).pop();
                      },
                      label: "Cancel",
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  Expanded(
                    child: RoundedButton(
                      style: RoundedButtonStyles.solid,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await updateItemQtyAndTask();
                        if (context.mounted) {
                          // Refresh task items list to show quantity update
                          widget.taskItemsListController.refresh();
                          // Refresh tasks list to show last updated
                          if (mounted) {
                            TaskListPagingController.of(context).refresh();
                          }
                        }
                      },
                      label: "Confirm",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        preventScan = false;
      });
    });
  }

  Future<void> updateItemQtyAndTask() async {
    final settings = ref.read(settingsProvider);
    final binNo = ref.read(binNumberProvider);
    try {
      if (settings.hasError || !settings.hasValue) {
        throw ErrorDescription(
          "An unexpected exception occurred: could not fetch settings",
        );
      } else if (binNo == null && settings.requireValue.enableBin) {
        throw ErrorDescription(
          "An unexpected exception occurred: bin no. is null",
        );
      } else if (currItem == null) {
        throw ErrorDescription(
          "An unexpected exception occurred: current item is null",
        );
      }

      bool enableBin = settings.requireValue.enableBin;
      final currTask = ref.read(currentTaskProvider)!;

      await updateScannedItemQuantity(
        item: currItem!,
        docType: currTask.docType,
        docNo: currTask.docNo,
        binNo: enableBin ? binNo : null,
      );

      // Update the task's last_updated field
      await updateLastUpdated(
        docNo: currTask.docNo,
        docType: currTask.docType,
      );
    } catch (err) {
      log("Error in openItemDetailsSheet: ${err.toString()}");
      openErrorBottomSheet(err.toString());
    }
  }
}

class CurrentBinWidget extends StatelessWidget {
  const CurrentBinWidget({
    super.key,
    required this.binNo,
    required this.taskItemsListController,
  });

  final String? binNo;
  final PagingController<int, TaskItem> taskItemsListController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Current BIN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              binNo ?? "N/A",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 12.sp),
            IconButton(
              onPressed: () {
                goToPageWithAnimation(
                  context: context,
                  page: ScanBinPage(
                    taskItemsListController: taskItemsListController,
                  ),
                  pushReplacement: true,
                );
              },
              icon: SvgPicture.asset(
                width: 20.sp,
                "assets/icons/edit.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
