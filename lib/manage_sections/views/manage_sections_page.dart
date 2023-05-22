import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_control_app/manage_sections/bloc/manage_sections_bloc.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/widgets/draggable_section_item.dart';
import 'package:food_control_app/manage_sections/widgets/rectangle_drag_target.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart'
    show FoodSpacesRepository;

class ManageSectionsPage extends StatefulWidget {
  const ManageSectionsPage({super.key});

  @override
  State<ManageSectionsPage> createState() => _ManageSectionsPageState();
}

class _ManageSectionsPageState extends State<ManageSectionsPage> {
  final FocusNode _nameFieldFocus = FocusNode();

  @override
  void dispose() {
    _nameFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectionAndRectangleList = [
      Section(name: 'Frigoríficio', index: 0),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Sessions',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.foodSpace?.id != current.foodSpace?.id ||
            previous.foodSpace?.sections != current.foodSpace?.sections,
        builder: (context, homeState) {
          return BlocProvider(
            create: (context) => ManageSectionsBloc(
              foodSpacesRepository: context.read<FoodSpacesRepository>(),
              sections: homeState.foodSpace?.sections
                      .map((s) => Section(name: s.name, index: s.index))
                      .toList() ??
                  [],
              foodSpace: homeState.foodSpace,
            ),
            child: BlocBuilder<ManageSectionsBloc, ManageSectionsState>(
              buildWhen: (previous, current) =>
                  previous.orderedSections != current.orderedSections ||
                  previous.selectedSectionIndex != current.selectedSectionIndex,
              builder: (context, sectionsState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, top: 20),
                        child: Text('Grab a section and change its order.'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...sectionsState.orderedSections
                                .mapIndexed(
                                  (index, element) => [
                                    if (sectionsState.selectedSectionIndex !=
                                        index)
                                      RectangleDragTarget(index: index),
                                    DraggableSectionItem(
                                        key: ValueKey(element.name),
                                        section: element,
                                        state: sectionsState),
                                  ],
                                )
                                .expand((widgets) => widgets),
                            RectangleDragTarget(
                                index: sectionsState.orderedSections.length),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
