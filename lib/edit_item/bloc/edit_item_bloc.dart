import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_control_app/edit_item/models/models.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({
    required FoodSpacesRepository foodSpacesRepository,
    required FoodSpace? foodSpace,
  })  : _foodSpacesRepository = foodSpacesRepository,
        _foodSpace = foodSpace,
        super(EditItemState()) {
    on<ItemAdded>(_onItemAdded);
    on<ItemEdited>(_onItemEdited);
    on<NameChanged>(_onNameChanged);
    on<ExpirationDateChanged>(_onExpirationDateChanged);
    on<QuantityChanged>(_onQuantityChanged);
    on<SectionChanged>(_onSectionChanged);
  }

  final FoodSpacesRepository _foodSpacesRepository;
  FoodSpace? _foodSpace;

  void setFoodSpace(FoodSpace foodSpace) {
    _foodSpace = foodSpace;
  }

  void _onItemAdded(ItemAdded event, Emitter<EditItemState> emit) {
    if (!Formz.validate([state.name, state.expirationDate, state.quantity])) {
      return;
    }
    final convertedExpirationDate =
        DateFormat('dd/MM/yyyy').parse(state.expirationDate.value);
    final parsedQuantity = int.parse(state.quantity.value);
    final newItem = Item(
      name: state.name.value,
      expirationDate: convertedExpirationDate,
      quantity: parsedQuantity,
    );
    _foodSpacesRepository.createItem(newItem, _foodSpace);
  }

  void _onItemEdited(ItemEdited event, Emitter<EditItemState> emit) {}

  void _onNameChanged(NameChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(name: Name.dirty(event.name)));
  }

  void _onExpirationDateChanged(
      ExpirationDateChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(
        expirationDate: ExpirationDate.dirty(event.expirationDate)));
  }

  void _onSectionChanged(SectionChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(section: event.section));
  }

  void _onQuantityChanged(QuantityChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(quantity: Quantity.dirty(event.quantity)));
  }
}
