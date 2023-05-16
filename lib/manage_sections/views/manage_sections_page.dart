import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/manage_sections/cubit/manage_sections_cubit.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/widgets/draggable_section_item.dart';
import 'package:food_control_app/manage_sections/widgets/rectangle_drag_target.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';
import 'package:collection/collection.dart';

class ManageSessions extends StatelessWidget {
  const ManageSessions({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionAndRectangleList = [
      Section(name: 'Frigoríficio', index: 0),
    ];
    return BlocProvider(
      create: (context) => ManageSectionsCubit(),
      child: BlocBuilder<ManageSectionsCubit, ManageSectionsState>(
        buildWhen: (previous, current) =>
            previous.orderedSections != current.orderedSections ||
            previous.selectedSectionIndex != current.selectedSectionIndex,
        builder: (context, state) {
          return Column(
            children: [
              Text(
                'Manage Sessions',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text('Grab a section and change its order.'),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 6.0),
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
                    RectangleDragTarget(index: state.orderedSections.length),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RedRectangle extends StatelessWidget {
  const RedRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        color: Colors.red,
      ),
    );
  }
}
