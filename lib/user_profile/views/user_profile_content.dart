import 'package:accordion/accordion.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/user_profile/cubit/user_profile_cubit.dart';

class UserProfileContent extends StatelessWidget {
  const UserProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit(
          authenticationRepository: context.read<AuthenticationRepository>()),
      child: Column(
        children: [
          Accordion(
            headerBorderRadius: 0,
            contentBorderColor: Colors.grey,
            scaleWhenAnimating: false,
            children: [
              AccordionSection(
                paddingBetweenClosedSections: 2,
                header: Text('Change Email'),
                content: Text('CHANGE EMAIL CONTENTS'),
              ),
              AccordionSection(
                paddingBetweenClosedSections: 2,
                header: Text('Change Password'),
                content: Text('CHANGE EMAIL CONTENTS'),
              ),
              AccordionSection(
                paddingBetweenClosedSections: 2,
                header: Text('End Session'),
                content: Column(
                  children: [
                    Text('Click in this button to end your session'),
                    _EndSessionButton(),
                  ],
                ),
              ),
              AccordionSection(
                paddingBetweenClosedSections: 2,
                header: Text('Delete Account'),
                content: Text('CHANGE EMAIL CONTENTS'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EndSessionButton extends StatelessWidget {
  const _EndSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.read<UserProfileCubit>().logOut();
        },
        child: Text('End Session'));
  }
}
