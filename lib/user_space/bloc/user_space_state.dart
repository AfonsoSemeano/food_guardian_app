part of 'user_space_bloc.dart';

abstract class UserSpaceState extends Equatable {
  const UserSpaceState();
  
  @override
  List<Object> get props => [];
}

class UserSpaceInitial extends UserSpaceState {}
