part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState(this.tabIndex, this.foodSpace, this.isFetching);

  final int tabIndex;
  final FoodSpace? foodSpace;
  final bool isFetching;

  HomeState copyWith({int? tabIndex, FoodSpace? foodSpace, bool? isFetching}) {
    return HomeState(tabIndex ?? this.tabIndex, foodSpace ?? this.foodSpace,
        isFetching ?? this.isFetching);
  }

  @override
  List<Object?> get props => [tabIndex, foodSpace, isFetching];
}

enum HomeStatus { fetching, ready }
