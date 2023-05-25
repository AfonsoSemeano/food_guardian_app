part of 'edit_item_bloc.dart';

class EditItemState extends Equatable {
  const EditItemState({
    this.name = const Name.pure(),
    this.expirationDate = const ExpirationDate.pure(),
    this.quantity = const Quantity.pure(),
    this.section,
    this.errorMessage,
  });

  final Name name;
  final ExpirationDate expirationDate;
  final Quantity quantity;
  final String? errorMessage;
  final Section? section;

  @override
  List<Object?> get props =>
      [name, expirationDate, quantity, section?.id, errorMessage];

  bool validateInputs() {
    return Formz.validate([name, expirationDate, quantity]);
  }

  EditItemState copyWith({
    Name? name,
    ExpirationDate? expirationDate,
    Quantity? quantity,
    Section? section,
    String? errorMessage,
  }) {
    return EditItemState(
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      section: section ?? this.section,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
