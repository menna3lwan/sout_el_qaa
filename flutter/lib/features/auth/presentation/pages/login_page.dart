import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// This screen has no Figma frame of its own; it reuses the same visual language (screen
/// background, pill inputs/buttons, Baloo Bhaijaan 2 heading) as every designed screen.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/characters/spongebob_cta_mascot.png',
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.l10n.authLoginTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.metaText,
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                    textInputAction: TextInputAction.done,
                    errorText: state.fieldErrors['password'] == null
                        ? null
                        : resolveMessageKey(
                            context,
                            state.fieldErrors['password']!,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: context.l10n.authLoginButton,
                    isLoading: state.status == AuthStatus.submitting,
                    onPressed: () => context.read<AuthCubit>().login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.authNoAccountPrompt,
                        style: context.textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () => context.push(RoutePaths.register),
                        child: Text(context.l10n.authRegisterLink),
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
