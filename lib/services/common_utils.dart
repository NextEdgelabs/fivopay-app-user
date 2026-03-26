import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/utils/theme_extension.dart';

import '../main.dart';
import '../utils/constants.dart';

bool isPdfDocument(String url) {
  final lowerUrl = url.toLowerCase();
  return lowerUrl.endsWith('.pdf') ||
      lowerUrl.contains('.pdf?') ||
      lowerUrl.contains('pdf') ||
      lowerUrl.contains('application/pdf');
}

showSnackbar(String msg, [Color color = Colors.red, int duration = 2]) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          msg,
          softWrap: true,
          style: Theme.of(bContext).textTheme.bodyMedium!.copyWith(
            // fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: Duration(seconds: duration),
      dismissDirection: DismissDirection.down,
      margin: const EdgeInsets.only(
        // bottom: _mediaQuery.size.height * 0.8,
        bottom: 40,
        right: 20,
        left: 20,
      ),
    ),
  );
}

Future<String> pdfToBase64(String url) async {
  try {
    final uri = Uri.parse(url);

    // Ensure it’s a valid URL
    if (!uri.isAbsolute) {
      throw Failure(message: "Invalid PDF URL");
    }

    final response = await http.get(
      uri,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36',
      },
    );

    if (response.statusCode != 200) {
      throw Failure(
        message: "Failed to download document. Status: ${response.statusCode}",
      );
    }

    // Convert response body bytes to Base64
    final base64String = base64Encode(response.bodyBytes);

    // Optional: prefix for displaying in <img src> or PDF viewers
    // return 'data:application/pdf;base64,$base64String';
    return base64String;
  } catch (e) {
    if (e is Failure) rethrow;
    throw Failure(message: "Unable to fetch Document: ${e.toString()}");
  }
}

LinearGradient get brandlinearGradient => LinearGradient(
  colors: [bContext.colors.gradientOne, bContext.colors.gradientTwo],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
Widget iconForType(String type) {
  switch (type) {
    case 'deposit':
      return const Icon(Icons.arrow_downward, color: AppColors.success);
    case 'withdraw':
      return const Icon(Icons.arrow_upward, color: AppColors.error);
    case 'transfer':
      return const Icon(Icons.compare_arrows, color: AppColors.info);
    case 'bonus':
      return const Icon(Icons.card_giftcard, color: AppColors.secondary);
    default:
      return const Icon(Icons.swap_horiz);
  }
}
