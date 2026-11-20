import 'package:flutter/material.dart';
import '../../common/styles.dart';

enum NotificationType { success, error, info, warning }

class AppNotification {
  AppNotification._();

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: EdgeInsets.zero,
        duration: duration,
        content: _AnimatedNotificationCard(
          title: title,
          message: message,
          type: type,
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: NotificationType.success,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: NotificationType.error,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: NotificationType.info,
    );
  }
}

class _AnimatedNotificationCard extends StatelessWidget {
  final String? title;
  final String message;
  final NotificationType type;

  const _AnimatedNotificationCard({
    this.title,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor;
    IconData iconData;
    String defaultTitle;

    switch (type) {
      case NotificationType.success:
        accentColor = AppColors.primary;
        iconData = Icons.check_circle_rounded;
        defaultTitle = 'Success';
      case NotificationType.error:
        accentColor = const Color(0xFFFF5252);
        iconData = Icons.error_rounded;
        defaultTitle = 'Error';
      case NotificationType.warning:
        accentColor = const Color(0xFFFFA000);
        iconData = Icons.warning_rounded;
        defaultTitle = 'Warning';
      case NotificationType.info:
        accentColor = const Color(0xFF38BDF8);
        iconData = Icons.info_rounded;
        defaultTitle = 'Information';
    }

    final displayTitle = title ?? defaultTitle;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.88 + (0.12 * value),
          alignment: Alignment.center,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Deep obsidian slate
              Color(0xFF1E293B), // Sleek midnight slate
            ],
          ),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: accentColor.withValues(alpha: 0.22),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Icon(
                  iconData,
                  color: accentColor,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Color(0xFFF1F5F9), // Crisp light text
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
