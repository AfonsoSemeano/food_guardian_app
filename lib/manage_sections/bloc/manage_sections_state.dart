part of 'manage_sections_bloc.dart';

class ManageSectionsState extends Equatable {
  ManageSectionsState(
      {List<Section>? newOrderedSections,
      this.selectedSectionIndex,
      this.isEditing = false,
      this.nameBeingEdited = '',
      this.sectionIndexBeingEdited = -1})
      : orderedSections = newOrderedSections ?? [];

  final List<Section> orderedSections;
  final int? selectedSectionIndex;
  final bool isEditing;
  final String nameBeingEdited;
  final int sectionIndexBeingEdited;

  @override
  List<Object?> get props => [
        orderedSections,
        selectedSectionIndex,
        isEditing,
        nameBeingEdited,
        sectionIndexBeingEdited
      ];

  ManageSectionsState copyWith({
    List<Section>? orderedSections,
    int? selectedSectionIndex,
    bool? isEditing,
    String? nameBeingEdited,
    int? sectionIndexBeingEdited,
  }) {
    return ManageSectionsState(
      newOrderedSections: orderedSections ?? this.orderedSections,
      selectedSectionIndex: selectedSectionIndex,
      isEditing: isEditing ?? this.isEditing,
      nameBeingEdited: nameBeingEdited ?? this.nameBeingEdited,
      sectionIndexBeingEdited:
          sectionIndexBeingEdited ?? this.sectionIndexBeingEdited,
    );
  }
}
