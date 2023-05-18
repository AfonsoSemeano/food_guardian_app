import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({
    required AuthenticationRepository authenticationRepository,
    required FoodSpacesRepository foodSpacesRepository,
  })  : _authenticationRepository = authenticationRepository,
        _foodSpacesRepository = foodSpacesRepository,
        super(UserProfileInitial());

  final AuthenticationRepository _authenticationRepository;
  final FoodSpacesRepository _foodSpacesRepository;

  void logOut() {
    unawaited(_foodSpacesRepository.saveFoodSpaceId(''));
    unawaited(_authenticationRepository.logOut());
  }
}
