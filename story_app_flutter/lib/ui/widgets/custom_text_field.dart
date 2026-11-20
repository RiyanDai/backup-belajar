import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../provider/password_visibility_provider.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final Widget? prefixIcon;
  final String? semanticsLabel;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.prefixIcon,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (isPassword) {
      return ChangeNotifierProvider(
        create: (_) => PasswordVisibilityProvider(),
        child: Consumer<PasswordVisibilityProvider>(
          builder: (context, provider, _) {
            return _buildField(
              context,
              obscureText: provider.obscureText,
              onToggleVisibility: provider.toggle,
            );
          },
        ),
      );
    }

    return _buildField(
      context,
      obscureText: false,
      onToggleVisibility: null,
    );
  }

  Widget _buildField(
    BuildContext context, {
    required bool obscureText,
    required VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: semanticsLabel ?? label,
          textField: true,
          obscured: isPassword && obscureText,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && obscureText,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: isPassword ? 1 : maxLines,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: onToggleVisibility,
                      tooltip: obscureText ? 'Show password' : 'Hide password',
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
