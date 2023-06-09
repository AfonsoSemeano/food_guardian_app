import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/edit_item/views/edit_item_page.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_control_app/manage_sections/models/models.dart';
import 'package:food_control_app/manage_sections/views/manage_sections_page.dart';
import 'package:food_control_app/manage_sections/widgets/widgets.dart';
import 'package:food_control_app/user_space/bloc/user_space_bloc.dart';
import 'package:food_control_app/user_space/widgets/infinite_items.dart';
import 'package:food_control_app/user_space/widgets/item_entry.dart';
import 'package:food_control_app/user_space/widgets/sections_bar.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart'
    show FoodSpacesRepository;

class UserSpace extends StatefulWidget {
  const UserSpace({super.key});

  @override
  State<UserSpace> createState() => _UserSpaceState();
}

class _UserSpaceState extends State<UserSpace> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSpaceBloc(
          foodSpacesRepository: context.read<FoodSpacesRepository>()),
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.foodSpace != current.foodSpace,
        builder: (context, state) {
          final sectionsTabController = TabController(
            length:
                state.foodSpace != null ? state.foodSpace!.sections.length : 1,
            vsync: this,
          );
          return Stack(
            children: [
              Column(
                children: [
                  SectionsBar(
                    tabController: sectionsTabController,
                    sections: state.foodSpace?.sections
                            .map((e) =>
                                Section(id: e.id, name: e.name, index: e.index))
                            .toList() ??
                        [],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: sectionsTabController,
                      children: [
                        ...state.foodSpace?.sections
                                .map(
                                  (section) => InfiniteItems(section: section),
                                )
                                .toList() ??
                            [],
                        // Center(child: Text('No this cant happen'))
                        // Add more tab content as needed
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                          isCreateMode: true,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
