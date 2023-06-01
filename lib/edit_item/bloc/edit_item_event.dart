part of 'edit_item_bloc.dart';

abstract class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object> get props => [];
}

class ClearStateRequested extends EditItemEvent {
  const ClearStateRequested();
}

class ItemChanged extends EditItemEvent {
  const ItemChanged(this.item);

  final Item? item;
}

class ItemAdded extends EditItemEvent {
  const ItemAdded();
}

class ItemEdited extends EditItemEvent {
  const ItemEdited();
}

class ImageChanged extends EditItemEvent {
  const ImageChanged(this.imageFile);

  final File? imageFile;
}

class ItemDeleted extends EditItemEvent {
  const ItemDeleted(this.item);

  final Item item;
}

class LoadingChanged extends EditItemEvent {
  const LoadingChanged({required this.isLoading});

  final bool isLoading;
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

// New event for button clicks
class QuantityButtonClicked extends EditItemEvent {
  const QuantityButtonClicked({required this.isIncrement});

  final bool isIncrement;
}
