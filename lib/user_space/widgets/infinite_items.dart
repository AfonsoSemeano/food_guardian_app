import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_control_app/user_space/widgets/item_entry.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteItems extends StatefulWidget {
  const InfiniteItems({this.section});

  final Section? section;

  @override
  _InfiniteItemsState createState() => _InfiniteItemsState();
}

class _InfiniteItemsState extends State<InfiniteItems> {
  static const _pageSize = 15;

  final PagingController<Item?, Item> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _fetchPage(Item? pageKey) async {
    try {
      final newItems =
          await context.read<FoodSpacesRepository>().fetchMoreItems(
                section: widget.section,
                lastItem: pageKey,
                currentFoodSpace: context.read<HomeBloc>().state.foodSpace,
              );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newItems.last;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) =>
      // Don't worry about displaying progress or error indicators on screen; the
      // package takes care of that. If you want to customize them, use the
      // [PagedChildBuilderDelegate] properties.
      PagedListView<Item?, Item>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Item>(
          firstPageProgressIndicatorBuilder: (context) => Scaffold(
            body: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          itemBuilder: (context, item, index) => ItemEntry(item: item),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
