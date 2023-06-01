import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/authentication/cubit/authentication_cubit.dart';
import 'package:food_control_app/theme.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBanner(),
          _EmailInput(),
          _PasswordInput(),
          _ConfirmPasswordInput(),
          _ErrorMessageText(),
          _SubmitButton(),
          _ChangeAuthTypeButton(),
        ],
      ),
    );
  }
}

class IconBanner extends StatelessWidget {
  const IconBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Food Guardian',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
        ),
        Container(
          height: 150,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('assets/food_guardian_icon.png'),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('email-input'),
          onChanged: (value) =>
              context.read<AuthenticationCubit>().emailChanged(value),
          decoration: InputDecoration(
            labelText: 'Email',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            helperText: '',
            errorText: !state.email.isPure && state.email.isNotValid
                ? 'The email is invalid.'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('password-input'),
          onChanged: (value) =>
              context.read<AuthenticationCubit>().passwordChanged(value),
          decoration: InputDecoration(
            labelText: 'Password',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            helperText: '',
            errorText: !state.password.isPure && state.password.isNotValid
                ? 'The password is invalid.'
                : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) =>
          previous.isLogin != current.isLogin ||
          previous.password != current.password ||
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return state.isLogin
            ? const SizedBox()
            : TextField(
                key: const Key('confirm-password-input'),
                obscureText: true,
                onChanged: (value) => context
                    .read<AuthenticationCubit>()
                    .confirmPasswordChanged(state.password.value, value),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  helperText: '',
                  errorText: !state.confirmPassword.isPure &&
                          state.confirmPassword.isNotValid
                      ? 'The password is invalid.'
                      : null,
                ),
              );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context);
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) =>
          previous.validateInputs() != current.validateInputs() ||
          previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return state.submissionStatus.isInProgress
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : state.submissionStatus.isSuccess
                ? Text('Success!!!')
                : ElevatedButton(
                    onPressed: !state.validateInputs()
                        ? null
                        : () => context
                            .read<AuthenticationCubit>()
                            .submitButtonPressed(),
                    child: Text("Submit"),
                  );
      },
    );
  }
}

class _ChangeAuthTypeButton extends StatelessWidget {
  const _ChangeAuthTypeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () => context
              .read<AuthenticationCubit>()
              .authTypeChanged(isLogin: !state.isLogin),
          child: Text(state.isLogin ? 'Change to Register' : 'Change to Login'),
        );
      },
    );
  }
}

class _ErrorMessageText extends StatelessWidget {
  const _ErrorMessageText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return Text(
          state.errorMessage ?? '',
          style: TextStyle(color: theme.colorScheme.error),
        );
      },
    );
  }
}
