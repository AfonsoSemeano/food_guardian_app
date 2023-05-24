import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/widgets/section_item.dart';

class AddSectionItem extends StatelessWidget {
  AddSectionItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
          constraints:
              const BoxConstraints(maxWidth: 36.0), // Set maximum width
        ),
        SectionItem(section: Section(name: '', index: index)),
      ],
    );
  }
}
