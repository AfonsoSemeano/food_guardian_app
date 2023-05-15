import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SectionsBar extends StatelessWidget {
  const SectionsBar(this._sectionsTabController);

  final TabController _sectionsTabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set a fixed width for the container
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: TabBar(
          controller: _sectionsTabController,
          onTap: (index) {},
          isScrollable: true, // Enable horizontal scrolling
          tabs: [
            Tab(text: 'Palavra gigante'),
            Tab(text: 'Massivosadasdasd'),
            Tab(text: 'Tab 3'),
            Tab(text: 'Tab 4'),
            Tab(text: 'Tab 5'),
            ElevatedButton(onPressed: () {}, child: Text('CLICK ME'))
            // Add more tabs as needed
          ],
        ),
      ),
    );
  }
}
