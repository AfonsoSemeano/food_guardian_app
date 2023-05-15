import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';

class UserSpace extends StatefulWidget {
  const UserSpace({super.key});

  @override
  State<UserSpace> createState() => _UserSpaceState();
}

class _UserSpaceState extends State<UserSpace>
    with SingleTickerProviderStateMixin {
  late TabController _sectionsTabController;
  late ScrollController _sectionsScrollController;

  @override
  void initState() {
    super.initState();
    _sectionsTabController = TabController(length: 5, vsync: this);
    _sectionsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _sectionsTabController.dispose();
    _sectionsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TabBar(
            controller: _sectionsTabController,
            isScrollable: true, // Enable horizontal scrolling
            tabs: [
              Tab(text: 'Palavra gigante'),
              Tab(text: 'Massivosadasdasd'),
              Tab(text: 'Tab 3'),
              Tab(text: 'Tab 4'),
              Tab(text: 'Tab 5'),
              ElevatedButton(onPressed: () {}, child: Text('CLICK ME'))
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _sectionsTabController,
            children: [
              Center(child: Text('Tab 1')),
              // Content of Tab 2
              Center(child: Text('Tab 2')),
              // Content of Tab 3
              Center(child: Text('Tab 3')),
              Center(child: Text('Tab 4')),
              Center(child: Text('Tab 5')),
              // Add more tab content as needed
            ],
          ),
        ),
      ],
    );
  }
}
