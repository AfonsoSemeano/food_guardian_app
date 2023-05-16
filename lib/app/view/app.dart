import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/app/bloc/app_bloc.dart';
import 'package:food_control_app/authentication/views/authentication_page.dart';
import 'package:food_control_app/home/views/home_page.dart';
import 'package:food_control_app/home/views/splash_page.dart';
import 'package:food_control_app/l10n/l10n.dart';
import 'package:food_control_app/theme.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
    required FoodSpacesRepository foodSpacesRepository,
  })  : _authenticationRepository = authenticationRepository,
        _foodSpacesRepository = foodSpacesRepository;

  final AuthenticationRepository _authenticationRepository;
  final FoodSpacesRepository _foodSpacesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _foodSpacesRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            AppBloc(authenticationRepository: _authenticationRepository),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: (state, pages) {
          switch (state) {
            case AppStatus.unauthenticated:
              return [AuthenticationPage.page()];
            case AppStatus.authenticated:
              return [HomePage.page()];
            case AppStatus.fetching:
              return [SplashPage.page()];
          }
        },
      ),
    );
  }
}
