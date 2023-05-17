part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState(this.tabIndex, this.foodSpace);

  final int tabIndex;
  final FoodSpace? foodSpace;

  HomeState copyWith({int? tabIndex, FoodSpace? foodSpace}) {
    return HomeState(tabIndex ?? this.tabIndex, foodSpace ?? this.foodSpace);
  }

  @override
  List<Object?> get props => [tabIndex, foodSpace];
}

enum HomeStatus { fetching, ready }
