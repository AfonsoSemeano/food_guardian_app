import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(int tabIndex) : super(HomeState(tabIndex));

  void changeTab(int index) {
    emit(state.copyWith(tabIndex: index));
  }
}
