import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/authentication/cubit/authentication_cubit.dart';
import 'views.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: AuthenticationPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (context) =>
              AuthenticationCubit(context.read<AuthenticationRepository>()),
          child: Center(
            child: AuthenticationForm(),
          ),
        ),
      ),
    );
  }
}
