part of 'edit_item_bloc.dart';

class EditItemState extends Equatable {
  const EditItemState({
    this.name = const Name.pure(),
    this.expirationDate = const ExpirationDate.pure(),
    this.quantity = const Quantity.pure(),
    this.errorMessage,
  });

  final Name name;
  final ExpirationDate expirationDate;
  final Quantity quantity;
  final String? errorMessage;

  @override
  List<Object?> get props => [name, expirationDate, errorMessage];

  EditItemState copyWith({
    Name? name,
    ExpirationDate? expirationDate,
    Quantity? quantity,
    String? errorMessage,
  }) {
    return EditItemState(
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
