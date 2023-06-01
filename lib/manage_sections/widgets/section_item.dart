import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/manage_sections/bloc/manage_sections_bloc.dart';
import 'package:food_control_app/manage_sections/models/models.dart';

class SectionItem extends StatefulWidget {
  const SectionItem(
      {super.key, required this.section, this.textFieldEnabled = true});

  final Section section;
  final bool textFieldEnabled;

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  TextEditingController _textEditingController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.section.name;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        context
            .read<ManageSectionsBloc>()
            .add(SectionNameChanged(widget.section.name, widget.section.index));
      } else if (context
              .read<ManageSectionsBloc>()
              .state
              .sectionIndexBeingEdited ==
          widget.section.index) {
        context.read<ManageSectionsBloc>().add(SectionNameEditFinished());
        if (widget.section.name.isEmpty) {
          _textEditingController.text = '';
        }
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.textFieldEnabled
        ? BlocSelector<ManageSectionsBloc, ManageSectionsState, int>(
            selector: (state) {
              return state.sectionIndexBeingEdited;
            },
            builder: (context, editedIndex) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextField(
                    // cursorColor: Theme.of(context).colorScheme.secondary,

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusColor: Theme.of(context).colorScheme.secondary,
                      hoverColor: Theme.of(context).colorScheme.secondary,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      hintText: 'Enter a new name',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: focusNode,
                    controller: _textEditingController,
                    enabled: widget.textFieldEnabled,
                    autofocus: editedIndex == widget.section.index,
                    onTapOutside: widget.textFieldEnabled &&
                            editedIndex == widget.section.index
                        ? (event) {
                            focusNode.unfocus();
                          }
                        : null,
                    onChanged: (value) => context
                        .read<ManageSectionsBloc>()
                        .add(SectionNameChanged(value, widget.section.index)),
                  ),
                ),
              );
            },
          )
        : Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                widget.section.name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize),
              ),
            ),
          );
  }
}
