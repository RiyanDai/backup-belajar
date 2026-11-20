import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

class ErrorHandler {
  ErrorHandler._();

  static String mapErrorToMessage(BuildContext context, dynamic error) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'An error occurred';

    final errStr = error.toString().toLowerCase();

    // 1. Connection / No Internet
    if (error is SocketException ||
        errStr.contains('socketexception') ||
        errStr.contains('failed host lookup') ||
        errStr.contains('network is unreachable') ||
        errStr.contains('no internet') ||
        errStr.contains('clientexception')) {
      return l10n.errorNoInternet;
    }

    // 2. Timeout
    if (error is TimeoutException ||
        errStr.contains('timeoutexception') ||
        errStr.contains('timed out') ||
        errStr.contains('timeout')) {
      return l10n.errorTimeout;
    }

    // 3. Server 500 / 502 / 503
    if (errStr.contains('500') ||
        errStr.contains('502') ||
        errStr.contains('503') ||
        errStr.contains('server error')) {
      return l10n.errorServer;
    }

    // 4. Duplicate email on register
    if (errStr.contains('email is already taken') ||
        errStr.contains('already registered') ||
        errStr.contains('already in use') ||
        errStr.contains('email_already_taken')) {
      return l10n.errorEmailAlreadyInUse;
    }

    // 5. Unauthorized / wrong credentials on login
    if (errStr.contains('unauthorized') ||
        errStr.contains('invalid password') ||
        errStr.contains('user not found') ||
        errStr.contains('user does not exist') ||
        errStr.contains('wrong password') ||
        errStr.contains('401')) {
      return l10n.errorInvalidCredentials;
    }

    // 6. Token expired
    if (errStr.contains('session expired') ||
        errStr.contains('token expired') ||
        errStr.contains('token invalid')) {
      return l10n.errorSessionExpired;
    }

    // 7. General cleaned up message from server
    final cleaned = error.toString().replaceFirst('Exception: ', '').trim();
    if (cleaned.isNotEmpty &&
        !cleaned.startsWith('{') &&
        !cleaned.contains('Instance of')) {
      return cleaned;
    }

    return l10n.errorUnknown;
  }
}

