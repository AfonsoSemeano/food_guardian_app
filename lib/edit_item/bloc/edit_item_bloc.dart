import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_control_app/edit_item/models/models.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'dart:io';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({
    required FoodSpacesRepository foodSpacesRepository,
  })  : _foodSpacesRepository = foodSpacesRepository,
        super(EditItemState()) {
    on<ItemAdded>(_onItemAdded);
    on<ItemEdited>(_onItemEdited);
    on<NameChanged>(_onNameChanged);
    on<ExpirationDateChanged>(_onExpirationDateChanged);
    on<QuantityChanged>(_onQuantityChanged);
    on<SectionChanged>(_onSectionChanged);
    on<QuantityButtonClicked>(_onQuantityButtonClicked);
    on<ImageChanged>(_onImageChanged);
    on<LoadingChanged>(_onLoadingChanged);
    on<ItemChanged>(_onItemChanged);
    on<ClearStateRequested>(_onClearStateRequested);
  }

  final FoodSpacesRepository _foodSpacesRepository;
  FoodSpace? _foodSpace;
  Item? _item;

  void setFoodSpace(FoodSpace? foodSpace) {
    _foodSpace = foodSpace;
  }

  void _onClearStateRequested(
      ClearStateRequested event, Emitter<EditItemState> emit) {
    emit(
      state.copyWith(
        name: const Name.pure(),
        expirationDate: const ExpirationDate.pure(),
        quantity: const Quantity.pure(),
        section: const Section(id: '', name: '', index: -1),
        imageFile: File(''),
        isLoading: false,
        item: Item(id: '', name: '', quantity: -1),
      ),
    );
  }

  void _onItemChanged(ItemChanged event, Emitter<EditItemState> emit) {
    final item = event.item;
    emit(
      state.copyWith(
        item: event.item,
        name: item != null ? Name.dirty(item.name) : Name.pure(),
        expirationDate: item?.expirationDate != null
            ? ExpirationDate.dirty(
                DateFormat('dd/MM/yyyy').format(item!.expirationDate!))
            : null,
        quantity:
            item != null ? Quantity.dirty(item.quantity.toString()) : null,
        section: item?.section != null
            ? Section(
                id: item!.section!.id,
                name: item.section!.name,
                index: item.section!.index,
              )
            : null,
        isLoading: false,
      ),
    );
  }

  void _onItemAdded(ItemAdded event, Emitter<EditItemState> emit) {
    if (!Formz.validate([state.name, state.expirationDate, state.quantity])) {
      return;
    }

    DateTime? convertedExpirationDate;
    if (state.expirationDate.value.isNotEmpty) {
      convertedExpirationDate =
          DateFormat('dd/MM/yyyy').parse(state.expirationDate.value);
    }
    final parsedQuantity = int.parse(state.quantity.value);
    final newItem = Item(
      id: '',
      name: state.name.value,
      expirationDate: convertedExpirationDate,
      section: state.section,
      quantity: parsedQuantity,
    );
    _foodSpacesRepository.createItem(newItem, state.imageFile, _foodSpace);
  }

  void _onItemEdited(ItemEdited event, Emitter<EditItemState> emit) {
    if (!Formz.validate([state.name, state.expirationDate, state.quantity])) {
      return;
    }
    DateTime? convertedExpirationDate;
    if (state.expirationDate.value.isNotEmpty) {
      convertedExpirationDate =
          DateFormat('dd/MM/yyyy').parse(state.expirationDate.value);
    }
    final parsedQuantity = int.parse(state.quantity.value);
    _foodSpacesRepository.updateItem(
      Item(
        id: state.item!.id,
        name: state.name.value,
        quantity: int.parse(state.quantity.value),
        expirationDate: convertedExpirationDate,
        section: state.section,
      ),
      state.imageFile,
      _foodSpace,
    );
  }

  void _onImageChanged(ImageChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(imageFile: event.imageFile ?? File('')));
  }

  void _onNameChanged(NameChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(name: Name.dirty(event.name)));
  }

  void _onExpirationDateChanged(
      ExpirationDateChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(
        expirationDate: ExpirationDate.dirty(event.expirationDate)));
  }

  void _onSectionChanged(SectionChanged event, Emitter<EditItemState> emit) {
    final section = event.section ?? const Section(id: '', name: '', index: -1);
    emit(state.copyWith(section: section));
  }

  void _onQuantityChanged(QuantityChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(quantity: Quantity.dirty(event.quantity)));
  }

  void _onQuantityButtonClicked(
      QuantityButtonClicked event, Emitter<EditItemState> emit) {
    if (state.quantity.isValid) {
      final parsedValue = int.parse(state.quantity.value);
      emit(
        state.copyWith(
          quantity: Quantity.dirty(
            (event.isIncrement ? parsedValue + 1 : parsedValue - 1).toString(),
          ),
        ),
      );
    } else {
      emit(state.copyWith(quantity: const Quantity.dirty()));
    }
  }

  void _onLoadingChanged(LoadingChanged event, Emitter<EditItemState> emit) {
    emit(state.copyWith(isLoading: event.isLoading));
  }
}
