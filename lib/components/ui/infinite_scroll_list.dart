import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteScrollList<T> extends ConsumerStatefulWidget {
  final PagingController<int, T> pagingController;
  final Function(int pageKey) fetchPage;
  final Widget Function(T item) itemBuilder;
  final Widget Function() separatorBuilder;
  final Widget loadingAnimation;

  const InfiniteScrollList({
    required this.fetchPage,
    required this.pagingController,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.loadingAnimation,
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
      widget.fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PagedListView.separated(
        pagingController: widget.pagingController,
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: (context, item, index) => widget.itemBuilder(item),
          firstPageProgressIndicatorBuilder: (context) =>
              widget.loadingAnimation,
          newPageProgressIndicatorBuilder: (context) => widget.loadingAnimation,
        ),
        separatorBuilder: (context, index) => widget.separatorBuilder(),
      ),
    );
  }

  @override
  void dispose() {
    widget.pagingController.dispose();
    super.dispose();
  }
}
