part of 'edit_item_bloc.dart';

abstract class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object> get props => [];
}

class ItemAdded extends EditItemEvent {
  const ItemAdded();
}

class ItemEdited extends EditItemEvent {
  const ItemEdited({required this.item});

  final Item item;
}

class NameChanged extends EditItemEvent {
  const NameChanged(this.name);

  final String name;
}

class ExpirationDateChanged extends EditItemEvent {
  const ExpirationDateChanged(this.expirationDate);

  final String expirationDate;
}

class SectionChanged extends EditItemEvent {
  const SectionChanged(this.section);

  final Section? section;
}

class QuantityChanged extends EditItemEvent {
  const QuantityChanged(this.quantity);

  final String quantity;
}
