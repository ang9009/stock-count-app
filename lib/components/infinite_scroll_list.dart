import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class InfiniteScrollList extends StatefulWidget {
  final AsyncValue<List<dynamic>> pendingListData;
  // For leaving space for floating button
  final double? bottomPadding;
  // The rendering function for each item card in the list
  final Widget Function(dynamic) getCurrItemCard;
  // The function to fetch more items when infinite scroll is triggered. Should return the extra items
  // which were fetched
  final Future<void> Function() getMoreItems;
  final Widget? separator;

  const InfiniteScrollList({
    this.bottomPadding,
    super.key,
    this.separator,
    required this.pendingListData,
    required this.getCurrItemCard,
    required this.getMoreItems,
  });

  @override
  State<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  late final ScrollController scrollController;

  Future<void>? pendingGetMoreItems;
  // Prevents extraneous getItem calls when new items are being fetched
  bool preventGetItemsCall = false;

  // When user scrolls to the bottom of the page, fetch more receipts
  void maxScrollListener() {
    // If there are no more items to be fetched, stop fetching
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!preventGetItemsCall) {
        setState(() {
          pendingGetMoreItems = widget.getMoreItems().then((addedItems) {
            preventGetItemsCall = false;
          });

          preventGetItemsCall = true;
        });
      }
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(maxScrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pendingListData.hasValue) {
      final items = widget.pendingListData.requireValue;

      return Expanded(
        child: ListView.separated(
          key: ObjectKey(items),
          padding: EdgeInsets.only(bottom: widget.bottomPadding ?? 0),
          controller: scrollController,
          itemBuilder: (context, index) {
            if (items.isEmpty) {
              return Text(
                "No results found",
                style: TextStyles.subHeading,
              );
            } else if (index != items.length) {
              final currItem = items[index];

              return widget.getCurrItemCard(currItem);
            } else {
              // Display loading status at bottom if new receipts are being fetched
              return FutureBuilder(
                future: pendingGetMoreItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.active) {
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: Theme.of(context).colorScheme.secondary,
                        size: 40,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return Text(
                      "An error occurred while fetching new items",
                      style: TextStyles.subHeading,
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            }
          },
          separatorBuilder: (context, index) =>
              widget.separator ??
              SizedBox(
                height: 13.sp,
              ),
          itemCount: items.length + 1,
        ),
      );
    } else if (widget.pendingListData.hasError) {
      return Column(
        children: [
          SizedBox(height: 12.sp),
          Text(
            "An error occurred: ${widget.pendingListData.error.toString()}",
            style: TextStyles.subHeading,
          ),
        ],
      );
    } else {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary),
        ),
      );
    }
  }
}
