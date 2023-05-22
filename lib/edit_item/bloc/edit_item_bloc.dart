import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc() : super(EditItemInitial()) {
    on<EditItemEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
