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
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      child: Text(section.name),
    );
  }
}
