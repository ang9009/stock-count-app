import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/scanning/barcode_scanner.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/scan_items_page.dart';
import 'package:stock_count/providers/scanner_data/scanner_data_providers.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';

class ScanBinPage extends ConsumerStatefulWidget {
  final PagingController<int, TaskItem> taskItemsListController;

  const ScanBinPage({
    super.key,
    required this.taskItemsListController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends ConsumerState<ScanBinPage> {
  // Modal form key
  final _formKey = GlobalKey<FormState>();
  final binTextController = TextEditingController();

  String scannedBinNo = "";
  bool preventScan = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Refer to BarcodeScanner for cutOutSize
    final cutOutSize = Adaptive.w(80);

    return BarcodeScanner(
      preventScan: preventScan,
      appBarTitle: Text(
        "Input bin number",
        style: TextStyle(
          fontSize: TextStyles.largeTitle.fontSize,
          color: Colors.white,
        ),
      ),
      onDetect: (BarcodeCapture capture) {
        setState(() {
          scannedBinNo = capture.barcodes.first.rawValue.toString();
        });

        setState(() {
          preventScan = true;
        });

        _confirmBinModalBuilder(context);
      },
      stackContent: [
        Positioned(
          left: 0,
          right: 0,
          // Half screen height + cutOutSize / 2 to make sure it's positioned above the cutout
          bottom: Adaptive.h(50) + (cutOutSize / 2) + 14.sp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Point device at bin code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: Adaptive.h(2),
          child: GestureDetector(
            onTap: () => _typeBinModalBuilder(context),
            child: Text(
              "Tap here to enter manually",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmBinModalBuilder(BuildContext context) {
    final verticalPadding = 20.sp;
    final horizontalPadding = 20.sp;
    final dividerPadding = 24.sp;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  0,
                ),
                child: Text(
                  "Confirm bin number",
                  style: TextStyles.largeTitle,
                ),
              ),
              Divider(
                color: AppColors.borderColor,
                height: dividerPadding,
              ),
              SizedBox(height: 12.sp),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        scannedBinNo,
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.clip,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 18.sp),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton(
                            style: RoundedButtonStyles.solid,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: "Cancel",
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.sp,
                                vertical: 15.sp,
                              ),
                            ),
                            onPressed: () {
                              confirmBinNoAndNavigate(scannedBinNo);
                            },
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      setState(() {
        preventScan = false;
      });
    });
  }

  void _typeBinModalBuilder(BuildContext context) {
    final verticalPadding = 20.sp;
    final horizontalPadding = 20.sp;
    final dividerPadding = 24.sp;

    setState(() {
      preventScan = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  0,
                ),
                child: Text(
                  "Enter bin number",
                  style: TextStyles.largeTitle,
                ),
              ),
              Divider(
                color: AppColors.borderColor,
                height: dividerPadding,
              ),
              SizedBox(height: 12.sp),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: binTextController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a bin number";
                          }
                          return null;
                        },
                        autofocus: true,
                        textAlign: TextAlign.left,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          hintStyle: TextStyle(
                            fontSize: TextStyles.heading.fontSize,
                            color: AppColors.lighterTextColor,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                            borderSide: const BorderSide(
                              color: AppColors.warning,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                            borderSide: const BorderSide(
                              color: AppColors.warning,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 17.sp,
                            vertical: 14.sp,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
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
                    SizedBox(height: 18.sp),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.borderColor,
                              ),
                              backgroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.sp,
                                vertical: 15.sp,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.sp,
                                vertical: 15.sp,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String binNo = binTextController.text;
                                confirmBinNoAndNavigate(binNo);
                              }
                            },
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      setState(() {
        preventScan = false;
      });
    });
  }

  void confirmBinNoAndNavigate(String binNo) {
    // Close modal
    Navigator.of(context).pop();

    ref.read(binNumberProvider.notifier).state = binNo;
    goToPageWithAnimation(
      context: context,
      page: ScanItemsPage(
        taskItemsListController: widget.taskItemsListController,
      ),
      pushReplacement: true,
    );
  }
}
