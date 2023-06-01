part of 'user_space_bloc.dart';

abstract class UserSpaceEvent extends Equatable {
  const UserSpaceEvent();

  @override
  List<Object> get props => [];
}

class ItemQuantityButtonClicked extends UserSpaceEvent {
  const ItemQuantityButtonClicked(
      {required this.newQuantity,
      required this.item,
      required this.currentFoodSpace});

  final int newQuantity;
  final Item item;
  final FoodSpace? currentFoodSpace;
}

class ItemDeleteButtonClicked extends UserSpaceEvent {
  const ItemDeleteButtonClicked(this.item, this.currentFoodSpace);

  final Item item;
  final FoodSpace? currentFoodSpace;
}
