import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/utils/object_classes.dart';

class ItemDetailsFloatingBtns extends ConsumerWidget {
  final Function clearItemChanges;
  final PagingController<int, ItemVariant> itemVariantsPagingController;
  final Function saveItemChanges;

  const ItemDetailsFloatingBtns({
    required this.clearItemChanges,
    super.key,
    required this.saveItemChanges,
    required this.itemVariantsPagingController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderColor),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.sp,
                  vertical: 15.sp,
                ),
              ),
              onPressed: () {
                clearItemChanges();
                itemVariantsPagingController.refresh();
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
          SizedBox(width: 16.sp),
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
                saveItemChanges();
              },
              child: Text(
                "Confirm changes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
