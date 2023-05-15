import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/authentication/cubit/authentication_cubit.dart';
import 'package:food_control_app/theme.dart';
import 'package:formz/formz.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _EmailInput(),
        _PasswordInput(),
        _ConfirmPasswordInput(),
        _ErrorMessageText(),
        _SubmitButton(),
        _ChangeAuthTypeButton(),
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
                onChanged: (value) => context
                    .read<AuthenticationCubit>()
                    .confirmPasswordChanged(state.password.value, value),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
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
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) =>
          previous.validateInputs() != current.validateInputs() ||
          previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return state.submissionStatus.isInProgress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : state.submissionStatus.isSuccess
                ? Text('Success!!!')
                : ElevatedButton(
                    onPressed: !state.validateInputs()
                        ? null
                        : () => context
                            .read<AuthenticationCubit>()
                            .submitButtonPressed(),
                    child: Text('Submit'),
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
