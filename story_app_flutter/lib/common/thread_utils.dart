import 'package:intl/intl.dart';

class ThreadUtils {
  ThreadUtils._();

  /// Formats date to a relative timestamp e.g. "5m", "2j", "17 Nov", etc.
  static String formatRelativeTime(DateTime dateTime, {bool isIndonesian = true}) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return isIndonesian ? 'Baru saja' : 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return isIndonesian ? '${difference.inHours}j' : '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return isIndonesian ? '${difference.inDays}h' : '${difference.inDays}d';
    } else {
      return DateFormat('d MMM').format(dateTime);
    }
  }

  /// Full timestamp for detail screens: "10:14 · 17 Nov 2026"
  static String formatDetailTime(DateTime dateTime) {
    return DateFormat('HH:mm · dd MMM yyyy').format(dateTime);
  }

  /// Formats numbers cleanly: 1200 -> 1.2K
  static String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
