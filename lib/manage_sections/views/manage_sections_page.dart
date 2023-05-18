import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_control_app/manage_sections/cubit/manage_sections_cubit.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/widgets/draggable_section_item.dart';
import 'package:food_control_app/manage_sections/widgets/rectangle_drag_target.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart'
    show FoodSpacesRepository;

class ManageSectionsPage extends StatelessWidget {
  const ManageSectionsPage({super.key});

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
      body: BlocProvider(
        create: (context) => ManageSectionsCubit(
          foodSpacesRepository: context.read<FoodSpacesRepository>(),
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.foodSpace?.sections != current.foodSpace?.sections,
          builder: (context, state) {
            return BlocBuilder<ManageSectionsCubit, ManageSectionsState>(
              buildWhen: (previous, current) =>
                  previous.orderedSections != current.orderedSections ||
                  previous.selectedSectionIndex != current.selectedSectionIndex,
              builder: (context, state) {
                return Column(
                  children: [
                    FutureBuilder(
                      future: context
                          .read<FoodSpacesRepository>()
                          .foodSpaceStream
                          .first,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(snapshot.data?.id ?? 'No id!!');
                        }
                        return Text('Loading');
                      },
                    ),
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
                          ...state.orderedSections
                              .mapIndexed(
                                (index, element) => [
                                  if (state.selectedSectionIndex != index)
                                    RectangleDragTarget(index: index),
                                  DraggableSectionItem(element, state),
                                ],
                              )
                              .expand((widgets) => widgets),
                          RectangleDragTarget(
                              index: state.orderedSections.length),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
