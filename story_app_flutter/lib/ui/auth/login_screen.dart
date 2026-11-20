import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/error_handler.dart';
import '../../common/styles.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/auth_provider.dart';
import '../widgets/custom_notification.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onRegisterTap,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      AppNotification.showSuccess(
        context,
        title: l10n.welcomeBack,
        message: l10n.loginSuccess,
      );
      widget.onLoginSuccess();
    } else {
      final errorMsg = ErrorHandler.mapErrorToMessage(
        context,
        authProvider.errorMessage,
      );
      AppNotification.showError(
        context,
        title: l10n.error,
        message: errorMsg,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Threads / Twitter Style Brand Monogram
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        width: 2.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.all_inclusive_rounded,
                        color: AppColors.primary,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Headline & Subtitle
                  Text(
                    l10n.welcomeBack,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loginTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Email input
                  CustomTextField(
                    label: l10n.emailLabel,
                    hint: l10n.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),
                    semanticsLabel: l10n.emailLabel,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.emailEmpty;
                      }
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return l10n.emailInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Password input
                  CustomTextField(
                    label: l10n.passwordLabel,
                    hint: l10n.passwordHint,
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    semanticsLabel: l10n.passwordLabel,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.passwordEmpty;
                      }
                      if (value.length < 8) {
                        return l10n.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Primary Pill Login Button
                  PrimaryButton(
                    text: l10n.loginButton,
                    isLoading: authProvider.isLoading,
                    onPressed: _handleLogin,
                    semanticsLabel: l10n.loginButton,
                  ),
                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.registerPrompt,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: widget.onRegisterTap,
                        child: Text(
                          l10n.registerLink,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
