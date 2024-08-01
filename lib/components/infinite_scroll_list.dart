import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class InfiniteScrollList extends ConsumerStatefulWidget {
  final AsyncValue<List<dynamic>> pendingListData;
  final int fetchLimit;
  // For leaving space for floating button
  final double? bottomPadding;
  // The rendering function for each item card in the list
  final Widget Function(dynamic) getCurrItemCard;
  // The function to fetch more items when infinite scroll is triggered. Should return the extra items
  // which were fetched
  final Future<List<dynamic>> Function({required int offset}) getMoreItems;
  // An optional list of providers that causes the list to re-render - used to reset the
  // offset and isEndOfList variables (anything that re-renders the list, e.g. filters changing)
  final List<StateProvider>? listRerenderDependencies;
  final Widget? separator;

  const InfiniteScrollList({
    this.bottomPadding,
    super.key,
    this.separator,
    required this.pendingListData,
    required this.fetchLimit,
    required this.getCurrItemCard,
    required this.getMoreItems,
    this.listRerenderDependencies,
  });

  @override
  ConsumerState<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends ConsumerState<InfiniteScrollList> {
  late int offset;
  late int offsetIncrement;
  late final ScrollController scrollController;

  Future<void>? pendingGetMoreItems;
  // Prevents extraneous getItem calls when new items are being fetched
  bool preventGetItemsCall = false;
  // Prevents extraneous getItem calls when no more items can be fetched
  bool isEndOfList = false;

  // When user scrolls to the bottom of the page, fetch more receipts
  void maxScrollListener() {
    // If there are no more items to be fetched, stop fetching
    if (isEndOfList) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!preventGetItemsCall) {
        setState(() {
          pendingGetMoreItems =
              widget.getMoreItems(offset: offset).then((addedItems) {
            preventGetItemsCall = false;

            if (addedItems.isNotEmpty) {
              offset += offsetIncrement;
            } else if (addedItems.isEmpty) {
              isEndOfList = true;
            }
          });

          preventGetItemsCall = true;
        });
      }
    }
  }

  @override
  void initState() {
    offset = widget.fetchLimit;
    offsetIncrement = widget.fetchLimit;
    scrollController = ScrollController();
    scrollController.addListener(maxScrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listRerenderDependencies != null) {
      for (StateProvider provider in widget.listRerenderDependencies!) {
        ref.listen(
          provider,
          (previous, next) {
            // Reset offset and isEndOfList
            offset = 0;
            isEndOfList = false;

            // If list isn't at the top, scroll to the top
            if (scrollController.offset !=
                scrollController.position.minScrollExtent) {
              scrollController
                  .jumpTo(scrollController.position.minScrollExtent);
            }
          },
        );
      }
    }

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
