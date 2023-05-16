import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:food_control_app/authentication/cubit/authentication_cubit.dart';
import 'package:food_control_app/firebase_options.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  //   log('onTransition(${bloc.runtimeType}, $transition)');

  //   // You can perform additional operations based on the bloc and transition
  //   if (bloc is AuthenticationCubit) {
  //     if (transition.nextState is AuthenticationState) {
  //       final nextState = transition.nextState as AuthenticationState;
  //       log('onTransition - AuthenticationCubit - nextState: $nextState');
  //     }
  //   }
  // }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function(AuthenticationRepository authenticationRepository,
          FoodSpacesRepository foodSpacesRepository)
      builder,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  final foodSpacesRepository = FoodSpacesRepository();

  await runZonedGuarded(
    () async =>
        runApp(await builder(authenticationRepository, foodSpacesRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
