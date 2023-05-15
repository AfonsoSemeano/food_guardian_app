import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_control_app/manage_sections/models/models.dart';

class SectionItem extends StatelessWidget {
  const SectionItem(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Text(section.name),
    );
  }
}
