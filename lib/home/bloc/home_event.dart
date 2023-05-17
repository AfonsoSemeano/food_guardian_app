part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class _FoodSpaceChanged extends HomeEvent {
  const _FoodSpaceChanged(this.foodSpace);

  final FoodSpace? foodSpace;
}

class TabChanged extends HomeEvent {
  const TabChanged(this.index);

  final int index;
}
