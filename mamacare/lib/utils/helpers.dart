import 'package:intl/intl.dart';

class AppHelpers {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static DateTime calculateEDD(DateTime lmp) {
    return lmp.add(const Duration(days: 280)); // 40 weeks
  }

  static int calculateWeeksPregnant(DateTime lmp) {
    return DateTime.now().difference(lmp).inDays ~/ 7;
  }

  static String getPregnancyTrimester(int weeks) {
    if (weeks < 13) return 'First Trimester';
    if (weeks < 27) return 'Second Trimester';
    return 'Third Trimester';
  }
}