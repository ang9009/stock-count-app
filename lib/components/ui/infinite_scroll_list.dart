import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InfiniteScrollList<T> extends ConsumerStatefulWidget {
  final PagingController<int, T> pagingController;
  final Widget Function(T item) itemBuilder;
  final Widget? separatorBuilder;
  final Widget loadingAnimation;
  final Future<List<T>> Function(int pageKey) getItems;
  final int fetchLimit;

  const InfiniteScrollList({
    required this.pagingController,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.loadingAnimation,
    required this.getItems,
    required this.fetchLimit,
    super.key,
  });

  @override
  ConsumerState<InfiniteScrollList<T>> createState() =>
      InfiniteScrollListState<T>();
}

class InfiniteScrollListState<T> extends ConsumerState<InfiniteScrollList<T>> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView.separated(
      key: ObjectKey(widget.pagingController.itemList),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: (context, item, index) => widget.itemBuilder(item),
        firstPageProgressIndicatorBuilder: (context) => widget.loadingAnimation,
        newPageProgressIndicatorBuilder: (context) => widget.loadingAnimation,
      ),
      separatorBuilder: (context, index) =>
          widget.separatorBuilder ?? SizedBox(height: 12.sp),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await widget.getItems(pageKey);

      final isLastPage = newItems.length < widget.fetchLimit;
      if (isLastPage) {
        widget.pagingController.appendLastPage(newItems);
      } else {
        int newPageKey = pageKey + widget.fetchLimit;
        widget.pagingController.appendPage(newItems, newPageKey);
      }
    } catch (error) {
      widget.pagingController.error = error;
    }
  }

  @override
  void dispose() {
    widget.pagingController.dispose();
    super.dispose();
  }
}
