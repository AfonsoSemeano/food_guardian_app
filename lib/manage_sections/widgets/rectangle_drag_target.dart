import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/manage_sections/cubit/manage_sections_cubit.dart';
import 'package:food_control_app/manage_sections/models/models.dart';

class RectangleDragTarget extends StatelessWidget {
  const RectangleDragTarget({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Section>(
      builder: (_, candidates, ___) {
        return candidates.length > 0
            ? RedRectangle()
            : Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Text('DRAG TO ME'),
              );
      },
      onAccept: (data) =>
          context.read<ManageSectionsCubit>().changeOrder(data, index),
    );
  }
}

class RedRectangle extends StatelessWidget {
  const RedRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.red,
    );
  }
}
