import 'dart:math';

import 'package:intl/intl.dart';

class AppTool {
  static String formatMoney(String text) {
    if (text.isEmpty) return text;

    // إزالة أي أحرف غير رقمية باستثناء الفواصل والنقاط
    String cleanedText = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // إذا كانت السلسلة فارغة
    if (cleanedText.isEmpty) return '';

    // التحقق من صلاحية الرقم (لمنع حالات النقاط المتعددة)
    if (double.tryParse(cleanedText) == null) {
      return text;
    }

    // تقسيم النص إلى جزء صحيح وجزء عشري للحفاظ على النقطة والأصفار العشرية أثناء الكتابة
    List<String> parts = cleanedText.split('.');

    // تنسيق الجزء الصحيح
    String integerPart = parts[0];
    if (integerPart.isNotEmpty) {
      final number = double.parse(integerPart);
      integerPart = NumberFormat('#,###').format(number);
    }

    // إذا كان هناك جزء عشري (أو نقطة في نهاية النص)
    if (parts.length > 1) {
      String decimalPart = parts[1];
      // تحديد عدد الخانات العشرية بخانتين فقط
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      return '$integerPart.$decimalPart';
    }

    return integerPart;
  }

  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(
    DateTime date, {
    String format = 'yyyy-MM-dd hh:mm a',
  }) {
    return DateFormat(format).format(date);
  }

  static String generatePassword({int length = 12}) {
    const String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lower = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '1234567890';
    const String special = '!@#\%^&*()_+';

    Random rnd = Random();
    List<String> chars = [];

    // Ensure at least one of each required type
    chars.add(upper[rnd.nextInt(upper.length)]);
    chars.add(lower[rnd.nextInt(lower.length)]);
    chars.add(numbers[rnd.nextInt(numbers.length)]);
    chars.add(special[rnd.nextInt(special.length)]);

    // Fill the rest randomly
    const String allChars = upper + lower + numbers + special;
    for (int i = 4; i < length; i++) {
      chars.add(allChars[rnd.nextInt(allChars.length)]);
    }

    // Shuffle the result so the required ones are not always at the start
    chars.shuffle();

    return chars.join();
  }
}
