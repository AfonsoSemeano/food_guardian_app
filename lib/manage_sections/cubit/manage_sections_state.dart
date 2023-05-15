part of 'manage_sections_cubit.dart';

class ManageSectionsState extends Equatable {
  ManageSectionsState({
    List<Section>? newOrderedSections,
    this.selectedSectionIndex,
  }) {
    orderedSections = newOrderedSections ??
        [
          Section(name: 'Frigorífico', index: 0),
          Section(name: 'Estante', index: 1),
          Section(name: 'Congelador', index: 2),
          Section(name: 'Especiarias', index: 3),
        ];
  }

  late List<Section> orderedSections;
  int? selectedSectionIndex;

  @override
  List<Object?> get props => [orderedSections, selectedSectionIndex];

  ManageSectionsState copyWith({
    List<Section>? orderedSections,
    int? selectedSectionIndex,
  }) {
    return ManageSectionsState(
      newOrderedSections: orderedSections ?? this.orderedSections,
      selectedSectionIndex: selectedSectionIndex,
    );
  }
}
