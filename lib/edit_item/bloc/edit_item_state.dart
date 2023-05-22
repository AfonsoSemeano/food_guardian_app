part of 'edit_item_bloc.dart';

abstract class EditItemState extends Equatable {
  const EditItemState();
  
  @override
  List<Object> get props => [];
}

class EditItemInitial extends EditItemState {}
