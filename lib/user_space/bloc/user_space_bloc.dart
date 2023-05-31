import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

part 'user_space_event.dart';
part 'user_space_state.dart';

class UserSpaceBloc extends Bloc<UserSpaceEvent, UserSpaceState> {
  UserSpaceBloc({required FoodSpacesRepository foodSpacesRepository})
      : _foodSpacesRepository = foodSpacesRepository,
        super(UserSpaceState()) {
    on<ItemQuantityButtonClicked>(_onItemQuantityButtonClicked);
  }

  final FoodSpacesRepository _foodSpacesRepository;

  void _onItemQuantityButtonClicked(
      ItemQuantityButtonClicked event, Emitter<UserSpaceState> emit) {
    _foodSpacesRepository.changeItemQuantity(
        event.item, event.newQuantity, event.currentFoodSpace);
  }
}
