import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share_plus/whatsapp_share_plus.dart';

class WhatsappUtils {
  /// Normalizes a phone number for WhatsApp (removes non-digits, adds 91 if 10-digit).
  static String normalizePhoneNumber(String? rawNumber) {
    final number = (rawNumber ?? '').trim();
    if (number.isEmpty) return '';

    // Remove spaces, -, (), + and any other non-digit characters
    var digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';

    // Convert 10-digit number to international format with country code 91
    if (digits.length == 10) {
      digits = '91$digits';
    } else if (digits.length == 11 && digits.startsWith('0')) {
      digits = '91${digits.substring(1)}';
    }

    if (digits.length < 7 || digits.length > 15) {
      return '';
    }

    return digits;
  }

  /// Builds a standard product inquiry message.
  static String buildInquiryMessage({
    required String productName,
    required String companyName,
    required String productId,
  }) {
    return '''Hello,

I am interested in:

Product:
${productName.trim()}

Company:
${companyName.trim()}

Product ID:
${productId.trim()}

Please share:

• Price
• MOQ
• Delivery Time
• Available Colors
• Stock Availability

Thank you.
Sent via Threado''';
  }

  /// Launches WhatsApp with a specific phone number and optional message.
  /// Returns true if launched successfully.
  static Future<bool> launchWhatsApp({required String phoneNumber, String? message}) async {
    final normalizedNumber = normalizePhoneNumber(phoneNumber);
    if (normalizedNumber.isEmpty) return false;

    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';

    final appUri = Uri.parse('whatsapp://send?phone=$normalizedNumber&text=$encodedMessage');
    final webUri = Uri.parse('https://wa.me/$normalizedNumber?text=$encodedMessage');

    try {
      if (await canLaunchUrl(appUri)) {
        return await launchUrl(appUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('WhatsApp launch error: $e');
    }
    return false;
  }

  /// Shares an image and text to WhatsApp using whatsapp_share_plus.
  /// Falls back to text-only launchWhatsApp if image sharing fails.
  static Future<bool> shareToWhatsAppWithImage({
    required String phoneNumber,
    required String message,
    required String imageUrl,
  }) async {
    final normalizedNumber = normalizePhoneNumber(phoneNumber);

    String? imagePath;
    if (imageUrl.isNotEmpty) {
      imagePath = await _downloadImage(imageUrl);
    }

    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        // Use whatsapp_share_plus for direct share (supports text + image + phone)
        await WhatsappSharePlus.shareImageToWhatsapp(
          text: message,
          phone: normalizedNumber.isNotEmpty ? normalizedNumber : null,
          imagePath: imagePath,
        );
      } else {
        // Use text-only share
        await WhatsappSharePlus.shareToWhatsapp(
          text: message,
          phone: normalizedNumber.isNotEmpty ? normalizedNumber : null,
        );
      }
      return true;
    } catch (e) {
      debugPrint('WhatsApp image share error: $e');
    }

    // Fallback to manual text-only launch if sharing via plugin fails
    return await launchWhatsApp(phoneNumber: phoneNumber, message: message);
  }

  /// Downloads an image to a temporary file and returns its path.
  static Future<String?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last.split('?').first;
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('Image download error: $e');
    }
    return null;
  }
}
