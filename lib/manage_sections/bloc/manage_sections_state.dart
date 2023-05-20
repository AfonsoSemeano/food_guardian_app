part of 'manage_sections_bloc.dart';

class ManageSectionsState extends Equatable {
  ManageSectionsState(
      {List<Section>? newOrderedSections,
      this.selectedSectionIndex,
      this.isEditing = false})
      : orderedSections = newOrderedSections ??
            [
              Section(name: 'Frigorífico', index: 0),
              Section(name: 'Estante', index: 1),
              Section(name: 'Congelador', index: 2),
              Section(name: 'Especiarias', index: 3),
            ];

  final List<Section> orderedSections;
  final int? selectedSectionIndex;
  final bool isEditing;

  @override
  List<Object?> get props => [orderedSections, selectedSectionIndex];

  ManageSectionsState copyWith({
    List<Section>? orderedSections,
    int? selectedSectionIndex,
    bool? isEditing,
  }) {
    return ManageSectionsState(
      newOrderedSections: orderedSections ?? this.orderedSections,
      selectedSectionIndex: selectedSectionIndex,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
