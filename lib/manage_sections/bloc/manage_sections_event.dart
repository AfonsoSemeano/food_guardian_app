part of 'manage_sections_bloc.dart';

abstract class ManageSectionsEvent extends Equatable {
  const ManageSectionsEvent();

  @override
  List<Object> get props => [];
}

class SectionsOrderChanged extends ManageSectionsEvent {
  const SectionsOrderChanged({
    required this.section,
    required this.newIndex,
  });

  final Section section;
  final int newIndex;
}

class SelectedSectionIndexChanged extends ManageSectionsEvent {
  const SelectedSectionIndexChanged(this.newIndex);

  final int? newIndex;
}

class SectionNameChanged extends ManageSectionsEvent {
  const SectionNameChanged(this.name, this.index);

  final String name;
  final int index;
}

class SectionNameEditFinished extends ManageSectionsEvent {
  const SectionNameEditFinished();
}
