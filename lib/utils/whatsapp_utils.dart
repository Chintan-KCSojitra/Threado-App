// import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:whatsapp_share_plus/whatsapp_share_plus.dart';

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
  /// Tries multiple URI schemes and fallback launch modes for 100% reliability on Android and iOS.
  static Future<bool> launchWhatsApp({required String phoneNumber, String? message}) async {
    final normalizedNumber = normalizePhoneNumber(phoneNumber);
    if (normalizedNumber.isEmpty) {
      debugPrint('WhatsApp launch error: Normalized phone number is empty.');
      return false;
    }

    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';

    final uris = [
      Uri.parse('whatsapp://send?phone=$normalizedNumber&text=$encodedMessage'),
      Uri.parse('https://wa.me/$normalizedNumber?text=$encodedMessage'),
      Uri.parse('https://api.whatsapp.com/send?phone=$normalizedNumber&text=$encodedMessage'),
    ];

    for (final uri in uris) {
      try {
        if (await canLaunchUrl(uri)) {
          final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (launched) return true;
        }
      } catch (e) {
        debugPrint('canLaunchUrl check failed for $uri: $e');
      }

      // Direct launch fallback without canLaunchUrl check (handles OS intent filters)
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) return true;
      } catch (e) {
        debugPrint('Direct launchUrl failed for $uri: $e');
      }
    }

    return false;
  }

  /// Redirects directly to WhatsApp chat using the phone number and pre-filled message.
  /// Note: File/Image sharing is currently disabled for both Android and iOS.
  static Future<bool> shareToWhatsAppWithImage({
    required String phoneNumber,
    required String message,
    required String imageUrl,
  }) async {
    /* File / Image sharing commented out for now:
    final normalizedNumber = normalizePhoneNumber(phoneNumber);

    String? imagePath;
    if (imageUrl.isNotEmpty) {
      imagePath = await _downloadImage(imageUrl);
    }

    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        await WhatsappSharePlus.shareImageToWhatsapp(
          text: message,
          phone: normalizedNumber.isNotEmpty ? normalizedNumber : null,
          imagePath: imagePath,
        );
        return true;
      }
    } catch (e) {
      debugPrint('WhatsApp image share error: $e');
    }
    */

    // Directly open WhatsApp chat with phone number and inquiry message on both Android and iOS
    return await launchWhatsApp(phoneNumber: phoneNumber, message: message);
  }

  /* File / Image download helper commented out while file sharing is disabled:
  static Future<String?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        var fileName = url.split('/').last.split('?').first;
        if (fileName.isEmpty || !fileName.contains('.')) {
          fileName = 'share_${DateTime.now().millisecondsSinceEpoch}.jpg';
        }
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('Image download error: $e');
    }
    return null;
  }
  */
}
