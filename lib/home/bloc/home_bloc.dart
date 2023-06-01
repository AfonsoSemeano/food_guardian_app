import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required FoodSpacesRepository foodSpacesRepository,
  })  : _foodSpacesRepository = foodSpacesRepository,
        super(const HomeState(0, null, true)) {
    on<_FoodSpaceChanged>(_onFoodSpaceChanged);
    on<TabChanged>(_onTabChanged);
    on<FoodSpaceFetched>(_onFoodSpaceFetched);

    _foodSpaceSubscription =
        _foodSpacesRepository.foodSpaceStream.listen((foodSpace) {
      add(_FoodSpaceChanged(foodSpace));
    });
  }

  final FoodSpacesRepository _foodSpacesRepository;
  late final StreamSubscription<FoodSpace?> _foodSpaceSubscription;

  Future<void> _onFoodSpaceFetched(
      FoodSpaceFetched event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isFetching: true));
    final foodSpaceResult = await _foodSpacesRepository.fetchFoodSpace();
    if (foodSpaceResult != null) {}
    emit(state.copyWith(isFetching: false, tabIndex: 0));
  }

  void _onFoodSpaceChanged(_FoodSpaceChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(foodSpace: event.foodSpace));
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(tabIndex: event.index));
  }

  @override
  Future<void> close() {
    _foodSpaceSubscription.cancel();
    return super.close();
  }
}
