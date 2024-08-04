import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/item_variants/item_variants_provider.dart';
import 'package:stock_count/utils/queries/get_item_details_qty_data.dart';

class TaskItemInfo extends ConsumerStatefulWidget {
  final String itemName;
  final String itemCode;
  final String docNo;
  final String docType;

  const TaskItemInfo({
    super.key,
    required this.itemName,
    required this.itemCode,
    required this.docNo,
    required this.docType,
  });

  @override
  ConsumerState<TaskItemInfo> createState() => _TaskItemInfoState();
}

class _TaskItemInfoState extends ConsumerState<TaskItemInfo> {
  late Future<int> pendingQtyRequired;

  final subHeadingStyle = TextStyle(
    fontSize: TextStyles.heading.fontSize,
    color: AppColors.lighterTextColor,
  );
  final infoStyle = TextStyle(
    fontSize: TextStyles.heading.fontSize,
    color: Colors.black,
    overflow: TextOverflow.clip,
  );

  @override
  void initState() {
    pendingQtyRequired = getItemQtyRequired(
      itemCode: widget.itemCode,
      docType: widget.docType,
      docNo: widget.docNo,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final qtyCollected = ref.watch(totalQtyCollectedProvider(
      docNo: widget.docNo,
      docType: widget.docType,
      itemCode: widget.itemCode,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Item name",
                style: subHeadingStyle,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                widget.itemName,
                style: infoStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Item code",
                style: subHeadingStyle,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                widget.itemCode,
                style: infoStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Quantity collected",
                style: subHeadingStyle,
              ),
            ),
            FutureBuilder(
              future: pendingQtyRequired,
              builder: (context, snapshot) {
                final String qtyRequired;

                if (snapshot.hasData) {
                  qtyRequired = snapshot.requireData.toString();
                } else if (snapshot.hasData) {
                  return const SizedBox.shrink();
                } else {
                  qtyRequired = "NaN";
                }

                return Expanded(
                  flex: 6,
                  child: Text(
                    "$qtyCollected/$qtyRequired",
                    style: infoStyle,
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
