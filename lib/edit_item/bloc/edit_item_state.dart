part of 'edit_item_bloc.dart';

class EditItemState extends Equatable {
  const EditItemState({
    this.name = const Name.pure(),
    this.expirationDate = const ExpirationDate.pure(),
    this.quantity = const Quantity.pure(),
    this.section,
    this.imageFile,
    this.errorMessage,
    this.isLoading = false,
    this.item,
  });

  final Name name;
  final ExpirationDate expirationDate;
  final Quantity quantity;
  final String? errorMessage;
  final Section? section;
  final File? imageFile;
  final bool isLoading;
  final Item? item;

  @override
  List<Object?> get props => [
        name,
        expirationDate,
        quantity,
        section?.id,
        imageFile?.path,
        isLoading,
        errorMessage,
        item
      ];

  bool validateInputs() {
    return Formz.validate([name, expirationDate, quantity]);
  }

  EditItemState copyWith({
    Name? name,
    ExpirationDate? expirationDate,
    Quantity? quantity,
    Section? section,
    File? imageFile,
    bool? isLoading,
    String? errorMessage,
    Item? item,
  }) {
    final newSection = section == null
        ? this.section
        : section.id.isEmpty
            ? null
            : section;
    final newImageFile = imageFile == null
        ? this.imageFile
        : imageFile.path.isEmpty
            ? null
            : imageFile;
    final newItem = item == null
        ? this.item
        : item.id.isEmpty
            ? null
            : item;
    return EditItemState(
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      section: newSection,
      imageFile: newImageFile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      item: newItem,
    );
  }
}
