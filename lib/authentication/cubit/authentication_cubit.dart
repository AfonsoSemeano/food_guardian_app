import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_control_app/authentication/models/models.dart';
import 'package:formz/formz.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState());
}
