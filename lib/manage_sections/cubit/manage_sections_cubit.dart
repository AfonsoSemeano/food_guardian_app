import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart'
    as food_repo;

part 'manage_sections_state.dart';

class ManageSectionsCubit extends Cubit<ManageSectionsState> {
  ManageSectionsCubit(
      {required food_repo.FoodSpacesRepository foodSpacesRepository})
      : _foodSpacesRepository = foodSpacesRepository,
        super(ManageSectionsState());

  final food_repo.FoodSpacesRepository _foodSpacesRepository;

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
    try {
      _foodSpacesRepository.storeSections(
        oldSections
            .map((s) => food_repo.Section(name: s.name, index: s.index))
            .toList(),
      );
    } catch (e) {}
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
