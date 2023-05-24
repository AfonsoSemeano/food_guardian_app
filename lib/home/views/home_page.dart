import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_control_app/theme.dart';
import 'package:food_control_app/user_profile/views/user_profile_content.dart';
import 'package:food_control_app/manage_sections/views/manage_sections_page.dart';
import 'package:food_control_app/user_space/views/views.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

class HomePage extends StatefulWidget {
  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.tabIndex != current.tabIndex ||
          previous.foodSpace?.id != current.foodSpace?.id,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'FoodGuardian',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: state.isFetching
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    context.read<HomeBloc>().add(TabChanged(index));
                  },
                  children: const [
                    Center(child: UserSpace()),
                    Center(child: UserProfileContent()),
                    Center(child: Text('FoodSpaces')),
                    Center(child: Text('Share')),
                    Center(child: Text('Settings')),
                  ],
                ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: theme.primaryColor,
            ),
            child: BottomNavigationBar(
              currentIndex: state.tabIndex,
              onTap: (index) {
                context.read<HomeBloc>().add(TabChanged(index));
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              backgroundColor: theme.primaryColor,
              selectedItemColor: Theme.of(context)
                  .colorScheme
                  .secondary, // Set the selected item color
              unselectedItemColor:
                  Colors.black, // Set the unselected item color
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.tab),
                  label: 'Your Space',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tab),
                  label: 'FoodSpaces',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tab),
                  label: 'Share',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tab),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
