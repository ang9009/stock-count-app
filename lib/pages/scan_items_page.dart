import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/scanning/barcode_scanner.dart';
import 'package:stock_count/components/scanning/bottom_drawer.dart';
import 'package:stock_count/components/scanning/scan_items_sheet_row_item.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/scan_bin_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/providers/task_items/task_items_provider.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';
import 'package:stock_count/utils/queries/get_scanned_item_data.dart';
import 'package:stock_count/utils/queries/update_scanned_item_quantity.dart';

class ScanItemsPage extends ConsumerStatefulWidget {
  const ScanItemsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanItemPageState();
}

class _ScanItemPageState extends ConsumerState<ScanItemsPage> {
  bool preventScan = false;
  ScannedItem? currItem;

  @override
  Widget build(BuildContext context) {
    final binNo = ref.watch(binNumberProvider);

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
        onBarcodeDetect(capture);
      },
      stackContent: [
        Positioned(
          left: 0,
          right: 0,
          bottom: Adaptive.h(16),
          child: Column(
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
                      goToRoute(
                        context: context,
                        page: const ScanBinPage(),
                        pushReplacement: true,
                      );
                    },
                    icon: SvgPicture.asset(
                      width: 20.sp,
                      "icons/edit.svg",
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 18.sp),
              RoundedButton(
                style: RoundedButtonStyles.solid,
                onPressed: () {
                  Navigator.pop(context);
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

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomDrawer(
          title: "Item details",
          contents: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScanItemsSheetRowItem(label: "Name", value: item.itemName),
              Divider(
                color: AppColors.borderColor,
                height: 24.sp,
              ),
              ScanItemsSheetRowItem(
                label: "Quantity collected",
                value:
                    "${item.qtyCollected.toString()} / ${item.qtyRequired.toString()}",
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
              ScanItemsSheetRowItem(
                label: "Item code",
                value: item.itemCode,
              ),
              Divider(
                color: AppColors.borderColor,
                height: 24.sp,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: RoundedButton(
                      style: RoundedButtonStyles.outlined,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: "Cancel",
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  Expanded(
                    child: RoundedButton(
                      style: RoundedButtonStyles.solid,
                      onPressed: () async {
                        final docData = ref.read(docDataProvider);
                        final binNo = ref.read(binNumberProvider);

                        await updateScannedItemQuantity(
                          item: currItem!,
                          docType: docData.docType!,
                          docNo: docData.docNo!,
                          binNo: binNo!,
                        ).onError((error, stackTrace) {
                          Navigator.pop(context);
                          openErrorBottomSheet(error.toString());
                        }).then((value) {
                          Navigator.pop(context);
                          // Refresh task items
                          ref.invalidate(taskItemsProvider);
                        });
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

  void onBarcodeDetect(BarcodeCapture capture) async {
    setState(() {
      preventScan = true;
    });

    String barcode = capture.barcodes.first.rawValue.toString();
    final docData = ref.read(docDataProvider);

    if (docData.docNo == null || docData.docType == null) {
      openErrorBottomSheet(
        "An unexpected exception occurred: current document data is null",
      );
    }

    await getScannedItemData(
      barcode,
      docData.docType!,
      docData.docNo!,
    ).then((item) {
      setState(() {
        currItem = item;
        openItemDetailsSheet();
      });
    }).onError((error, stackTrace) {
      openErrorBottomSheet(error.toString());
    });
  }
}
