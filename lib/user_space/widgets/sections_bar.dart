import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/views/manage_sections_page.dart';

class SectionsBar extends StatelessWidget {
  const SectionsBar(
      {required List<Section> sections, required TabController tabController})
      : _tabController = tabController,
        _sections = sections;

  final List<Section> _sections;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: Row(
          mainAxisSize: MainAxisSize.min, // Occupy only necessary space
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                ..._sections.map((e) => Tab(text: e.name)).toList(),
              ],
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ManageSectionsPage(),
                  ),
                );
              },
              label: Text('New'),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
