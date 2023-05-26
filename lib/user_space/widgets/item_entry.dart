import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemEntry extends StatelessWidget {
  const ItemEntry({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Controls the shadow depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Controls the corner radius
      ),
      child: ListTile(
          title: Text('Title!'),
          subtitle: Row(
            children: [
              Icon(
                MdiIcons.timerSandFull,
                color: Colors.orange,
              ),
              Text('In 5 days'),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.remove,
                      size: 15,
                    ),
                  ),
                  Text('2'),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
