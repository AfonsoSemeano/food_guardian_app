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

class RedRectangle extends StatefulWidget {
  const RedRectangle({super.key});

  @override
  State<RedRectangle> createState() => _RedRectangleState();
}

class _RedRectangleState extends State<RedRectangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween<double>(begin: 20.0, end: 50.0).animate(curvedAnimation);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: _animation.value,
        );
      },
    );
  }
}
