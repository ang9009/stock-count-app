import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/item_variants/item_variants_provider.dart';

class ItemDetailsFloatingBtns extends ConsumerWidget {
  final Function clearItemChanges;
  final ItemVariantsProvider itemsProvider;
  final Function saveItemChanges;

  const ItemDetailsFloatingBtns({
    required this.clearItemChanges,
    super.key,
    required this.saveItemChanges,
    required this.itemsProvider,
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
                ref.invalidate(itemsProvider);
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
