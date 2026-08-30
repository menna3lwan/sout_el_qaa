import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Not in Figma, same reasoning as LoginPage; required so Login isn't a dead end with no way to
/// create an account.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.authRegisterTitle)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            context.go(RoutePaths.home);
          }
          if (state.status == AuthStatus.failure &&
              state.failureMessageKey != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  resolveMessageKey(context, state.failureMessageKey!),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: context.l10n.authUsernameLabel,
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    errorText: state.fieldErrors['username'] == null
                        ? null
                        : resolveMessageKey(
                            context,
                            state.fieldErrors['username']!,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: context.l10n.authEmailLabel,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: state.fieldErrors['email'] == null
                        ? null
                        : resolveMessageKey(
                            context,
                            state.fieldErrors['email']!,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: context.l10n.authPasswordLabel,
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    errorText: state.fieldErrors['password'] == null
                        ? null
                        : resolveMessageKey(
                            context,
                            state.fieldErrors['password']!,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: context.l10n.authConfirmPasswordLabel,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    errorText: state.fieldErrors['confirmPassword'] == null
                        ? null
                        : resolveMessageKey(
                            context,
                            state.fieldErrors['confirmPassword']!,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: context.l10n.authRegisterButton,
                    isLoading: state.status == AuthStatus.submitting,
                    onPressed: () => context.read<AuthCubit>().register(
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.authHaveAccountPrompt,
                        style: context.textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(context.l10n.authLoginLink),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
