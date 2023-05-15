import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:food_control_app/manage_sections/models/models.dart';

part 'manage_sections_state.dart';

class ManageSectionsCubit extends Cubit<ManageSectionsState> {
  ManageSectionsCubit() : super(ManageSectionsState());

  void changeOrder(Section section, int newIndex) {
    final oldSections = [
      ...state.orderedSections.map((element) {
        return Section(name: element.name, index: element.index);
      })
    ];
    final foundSection = oldSections[section.index];
    if (newIndex != oldSections.length) {
      oldSections.insert(newIndex, foundSection);
    } else {
      oldSections.add(foundSection);
    }
    if (newIndex > section.index) {
      oldSections.removeAt(section.index);
    } else {
      oldSections.removeAt(section.index + 1);
    }

    _updateEachSectionOnPosition(oldSections);
    emit(state.copyWith(orderedSections: oldSections));
  }

  void changeSelectedIndex(Section? selectedSection) {
    emit(state.copyWith(selectedSectionIndex: selectedSection?.index));
  }

  void _updateEachSectionOnPosition(List<Section> sections) {
    sections.forEachIndexed((index, section) {
      section.index = index;
    });
  }
}
