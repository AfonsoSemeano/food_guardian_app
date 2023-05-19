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
        super(const HomeState(0, null)) {
    on<_FoodSpaceChanged>(_onFoodSpaceChanged);
    on<TabChanged>(_onTabChanged);

    _foodSpaceSubscription =
        _foodSpacesRepository.foodSpaceStream.listen((foodSpace) {
      add(_FoodSpaceChanged(foodSpace));
    });
    _foodSpacesRepository.fetchFoodSpace();
  }

  final FoodSpacesRepository _foodSpacesRepository;
  late final StreamSubscription<FoodSpace?> _foodSpaceSubscription;

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