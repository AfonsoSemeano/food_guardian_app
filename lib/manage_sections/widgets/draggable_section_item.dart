import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/manage_sections/bloc/manage_sections_bloc.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';

class DraggableSectionItem extends StatefulWidget {
  const DraggableSectionItem(
      {super.key, required this.section, required this.state});

  final Section section;
  final ManageSectionsState state;

  @override
  State<DraggableSectionItem> createState() => _DraggableSectionItemState();
}

class _DraggableSectionItemState extends State<DraggableSectionItem> {
  bool isBeingDragged = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Draggable<Section>(
            maxSimultaneousDrags:
                widget.state.selectedSectionIndex == null ? 1 : 0,
            child: const Icon(
              Icons.drag_indicator,
              size: 30,
            ),
            feedback: Container(
              width: 300.0,
              child: Card(
                child: Row(
                  children: [
                    const Icon(
                      Icons.drag_indicator,
                      size: 30,
                    ),
                    SectionItem(
                      section: widget.section,
                      textFieldEnabled: false,
                    ),
                  ],
                ),
              ),
            ),
            data: widget.section,
            childWhenDragging: const SizedBox(),
            onDragStarted: () {
              setState(() {
                isBeingDragged = true;
              });
              context
                  .read<ManageSectionsBloc>()
                  .add(SelectedSectionIndexChanged(widget.section.index));
            },
            onDragEnd: (_) {
              setState(() {
                isBeingDragged = false;
              });
              context
                  .read<ManageSectionsBloc>()
                  .add(const SelectedSectionIndexChanged(null));
            },
          ),
          if (!isBeingDragged) SectionItem(section: widget.section),
        ],
      ),
    );
  }
}
