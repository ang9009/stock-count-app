import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/providers/current_page/current_page_provider.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';
import 'package:stock_count/providers/task_list_paging_controller.dart';
import 'package:stock_count/utils/helpers/show_loading_overlay.dart';
import 'package:stock_count/utils/object_classes.dart';
import 'package:stock_count/utils/queries/download_receipt.dart';

// Downloads multiple receipts, then returns back to the homescreen.
// Used on the look for receipt online page
// Can download singular receipts by wrapping it with list brackets

void downloadReceiptsThenHome({
  required List<ReceiptDownloadOption> receipts,
  required String parentType,
  required BuildContext context,
  required ref,
}) async {
  showLoadingOverlay(context);

  try {
    for (ReceiptDownloadOption receipt in receipts) {
      await downloadReceipt(
        parentType,
        receipt.docType,
        receipt.docNo,
      );
    }
  } catch (err) {
    log(err.toString());
    if (context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      showErrorSnackbar(context, "An error occurred: ${err.toString()}");
      return;
    }
  }

  if (context.mounted) {
    Navigator.popUntil(context, (route) => route.isFirst);
    // Go back to homepage
    ref.read(currentPageProvider.notifier).setCurrentPage(0);
    final successSnackBar = SnackBar(
      content: Text(
          "${receipts.length} task${receipts.length == 1 ? "" : "s"} successfully downloaded"),
    );
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);

    invalidateTaskListStates(ref);
    TaskListPagingController.of(context).refresh();
  }
}
