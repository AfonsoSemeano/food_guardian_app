import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/manage_sections/cubit/manage_sections_cubit.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';

class DraggableSectionItem extends StatelessWidget {
  const DraggableSectionItem(this.section, this.state);

  final Section section;
  final ManageSectionsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.0),
      child: Draggable<Section>(
        maxSimultaneousDrags: state.selectedSectionIndex == null ? 1 : 0,
        child: SectionItem(section),
        feedback: Card(
          color: Colors.blue, // Customize the background color
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              section.name,
              style: const TextStyle(
                color: Colors.white, // Customize the text color
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        data: section,
        childWhenDragging: SizedBox(),
        onDragStarted: () =>
            context.read<ManageSectionsCubit>().changeSelectedIndex(section),
        onDragEnd: (_) =>
            context.read<ManageSectionsCubit>().changeSelectedIndex(null),
      ),
    );
  }
}
