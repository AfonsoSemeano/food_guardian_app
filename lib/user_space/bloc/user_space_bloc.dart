import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_space_event.dart';
part 'user_space_state.dart';

class UserSpaceBloc extends Bloc<UserSpaceEvent, UserSpaceState> {
  UserSpaceBloc() : super(UserSpaceInitial()) {
    on<UserSpaceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
