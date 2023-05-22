import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart'
    as food_repo;

part 'manage_sections_event.dart';
part 'manage_sections_state.dart';

class ManageSectionsBloc
    extends Bloc<ManageSectionsEvent, ManageSectionsState> {
  ManageSectionsBloc({
    required food_repo.FoodSpacesRepository foodSpacesRepository,
    List<Section>? sections,
    required this.foodSpace,
  })  : _foodSpacesRepository = foodSpacesRepository,
        super(ManageSectionsState(newOrderedSections: sections)) {
    on<SectionsOrderChanged>(_onSectionsOrderChanged);
    on<SelectedSectionIndexChanged>(_onSelectedSectionIndexChanged);
    on<SectionNameChanged>(_onSectionNameChanged);
    on<SectionNameEditFinished>(_onSectionNameEditFinished);
  }

  final food_repo.FoodSpacesRepository _foodSpacesRepository;
  final food_repo.FoodSpace? foodSpace;

  void _onSectionsOrderChanged(
      SectionsOrderChanged event, Emitter<ManageSectionsState> emit) {
    final oldSections = [
      ...state.orderedSections.map((element) {
        return Section(name: element.name, index: element.index);
      })
    ];
    final section = event.section;
    final newIndex = event.newIndex;
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
          foodSpace);
    } catch (e) {
      print('error being thrown!!');
    }
  }

  void _updateEachSectionOnPosition(List<Section> sections) {
    sections.forEachIndexed((index, section) {
      section.index = index;
    });
  }

  void _onSelectedSectionIndexChanged(
      SelectedSectionIndexChanged event, Emitter<ManageSectionsState> emit) {
    emit(state.copyWith(selectedSectionIndex: event.newIndex));
  }

  void _onSectionNameChanged(
      SectionNameChanged event, Emitter<ManageSectionsState> emit) {
    if (!state.isEditing) {
      emit(state.copyWith(
          isEditing: true,
          nameBeingEdited: event.name,
          sectionIndexBeingEdited: event.index));
    }
    emit(state.copyWith(nameBeingEdited: event.name));
  }

  void _onSectionNameEditFinished(
      SectionNameEditFinished event, Emitter<ManageSectionsState> emit) {
    if (!state.isEditing) {
      return;
    }
    final validatedName = _validateName(state.nameBeingEdited,
        state.orderedSections, state.sectionIndexBeingEdited);
    final oldSections = [
      ...state.orderedSections.map((element) {
        if (element.index == state.sectionIndexBeingEdited) {
          return Section(name: validatedName, index: element.index);
        }
        return Section(name: element.name, index: element.index);
      })
    ];
    emit(state.copyWith(
      orderedSections: oldSections,
      isEditing: false,
      sectionIndexBeingEdited: -1,
      nameBeingEdited: '',
    ));
    try {
      _foodSpacesRepository.storeSections(
          oldSections
              .map((s) => food_repo.Section(name: s.name, index: s.index))
              .toList(),
          foodSpace);
    } catch (e) {
      emit(
        state.copyWith(
          orderedSections: foodSpace?.sections
              .map((e) => Section(name: e.name, index: e.index))
              .toList(),
        ),
      );
    }
  }

  String _validateName(String name, List<Section> sections, int index) {
    var number = 1;
    var shouldRepeat = true;
    var newName = name;
    while (shouldRepeat) {
      shouldRepeat = false;
      for (final section in sections) {
        if (section.index != index && section.name == name) {
          newName = '${name.trim()} $number';
          number += 1;
          shouldRepeat = true;
        }
      }
    }
    return newName;
  }
}
