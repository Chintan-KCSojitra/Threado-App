import 'package:thredo/app_config.dart';
import 'package:thredo/legal/legal_document_type.dart';

class LegalSection {
  const LegalSection({required this.title, required this.paragraphs});

  final String title;
  final List<String> paragraphs;
}

class ThredoLegalContent {
  ThredoLegalContent._();

  static const String _appName = AppConfig.appName;
  static const String _supportEmail = AppConfig.supportEmail;

  static List<LegalSection> sectionsFor(LegalDocumentType type) {
    switch (type) {
      case LegalDocumentType.privacyPolicy:
        return _privacyPolicy;
      case LegalDocumentType.termsAndConditions:
        return _termsAndConditions;
    }
  }

  static final List<LegalSection> _privacyPolicy = [
    const LegalSection(
      title: 'Introduction',
      paragraphs: [
        'This Privacy Policy explains how $_appName ("Thredo", "we", "us", or "our") collects, uses, stores, and protects your information when you use our mobile application for textile and thread discovery, sourcing, and related features.',
        'By creating an account or using the app, you agree to the practices described in this policy. If you do not agree, please discontinue use of the app.',
      ],
    ),
    const LegalSection(
      title: 'Information we collect',
      paragraphs: [
        'Account information: mobile phone number used for OTP sign-in, authentication tokens, and basic profile details stored on our servers after verification.',
        'Usage and preferences: products you view, categories you browse, search queries, wishlist items, filter selections, language preference, and in-app actions such as reviews or event logs sent to our API.',
        'Device and technical data: device model, operating system version, app version, network connectivity, and similar diagnostics needed to operate and secure the service.',
        'Camera and media (with your permission): images or video frames when you use Thread Match or AR shade matching, fabric photos you upload for matching, and product media you view or share. We process these features only when you choose to use them.',
        'Photos and storage (with your permission): on some devices we may request access to detect screenshots or to save shared content, solely to support features you initiate.',
        'Communications: when you contact a supplier via WhatsApp or other channels linked from the app, that interaction occurs outside $_appName and is governed by the third-party provider\'s policies.',
      ],
    ),
    const LegalSection(
      title: 'How we use your information',
      paragraphs: [
        'To authenticate you and maintain your session.',
        'To display product catalogs, company profiles, categories, banners, videos, and personalized lists such as your wishlist.',
        'To run search, filters, thread/colour matching, and related recommendations.',
        'To improve performance, fix errors, prevent abuse, and understand how features are used.',
        'To send service-related messages (for example OTP codes) and respond to support requests.',
        'To comply with applicable law and enforce our Terms and Conditions.',
      ],
    ),
    const LegalSection(
      title: 'How we share information',
      paragraphs: [
        'Service providers: we transmit data to our backend API and hosting partners that operate the $_appName platform on our behalf, under contractual confidentiality obligations.',
        'Suppliers and listings: product names, images, specifications, and company contact details shown in the app are provided by third-party sellers or data partners. When you inquire about a product, you may share information directly with that supplier.',
        'Legal requirements: we may disclose information if required by law, court order, or to protect the rights, safety, or security of users, $_appName, or others.',
        'We do not sell your personal information to third-party advertisers.',
      ],
    ),
    const LegalSection(
      title: 'Data retention and security',
      paragraphs: [
        'We retain account and usage data for as long as your account is active and for a reasonable period afterward to meet legal, accounting, or security needs.',
        'When you delete your account through the Profile screen, we process deletion requests on our servers in accordance with our retention schedule; some anonymized or backup copies may persist for a limited time.',
        'We use industry-standard measures such as encrypted transport (HTTPS), access controls, and secure token storage on your device where supported. No method of transmission or storage is completely secure.',
      ],
    ),
    const LegalSection(
      title: 'Your choices and rights',
      paragraphs: [
        'You may update language settings and manage wishlist items within the app.',
        'You may revoke camera, photo, or storage permissions in your device settings; certain features may no longer work.',
        'You may log out or delete your account from the Profile screen.',
        'Depending on applicable law, you may request access to, correction of, or deletion of personal data by contacting us at $_supportEmail.',
      ],
    ),
    const LegalSection(
      title: 'Children',
      paragraphs: [
        '$_appName is intended for business users and traders. The app is not directed at children under 18, and we do not knowingly collect personal information from children.',
      ],
    ),
    const LegalSection(
      title: 'Changes to this policy',
      paragraphs: [
        'We may update this Privacy Policy from time to time. The "Last updated" date at the top of this screen will change when we do. Continued use of the app after changes constitutes acceptance of the revised policy.',
      ],
    ),
    const LegalSection(
      title: 'Contact us',
      paragraphs: [
        'For privacy questions or requests, email $_supportEmail with the subject line "Privacy – $_appName".',
      ],
    ),
  ];

  static final List<LegalSection> _termsAndConditions = [
    const LegalSection(
      title: 'Agreement to terms',
      paragraphs: [
        'These Terms and Conditions ("Terms") govern your access to and use of the $_appName mobile application ("App") operated by Thredo. By downloading, registering, or using the App, you agree to these Terms and our Privacy Policy.',
        'If you do not agree, do not use the App.',
      ],
    ),
    const LegalSection(
      title: 'Eligibility and account',
      paragraphs: [
        'The App is designed for textile traders, buyers, and business users. You must be at least 18 years old and able to enter a binding contract in your jurisdiction.',
        'You register using a valid mobile number and OTP verification. You are responsible for keeping your device and account access secure and for all activity under your account.',
        'You must provide accurate information and notify us promptly of unauthorized use at $_supportEmail.',
      ],
    ),
    const LegalSection(
      title: 'Description of services',
      paragraphs: [
        '$_appName helps you discover threads, fabrics, and related products; browse categories and company profiles; save wishlists; search and filter catalogs; view product images and videos; match thread colours using camera or uploaded images; read and submit company reviews; and contact suppliers (for example via WhatsApp) about products.',
        'Product availability, pricing, minimum order quantities, delivery, and quality are determined by individual suppliers. $_appName displays information supplied by third parties and does not guarantee accuracy, stock, or outcomes of colour-matching tools.',
      ],
    ),
    const LegalSection(
      title: 'Acceptable use',
      paragraphs: [
        'You agree not to misuse the App, including by: violating laws; infringing intellectual property; scraping or reverse-engineering the service; uploading malicious code; harassing others; impersonating any person; or using automated means to access the API without permission.',
        'Colour match, AR shade, and thread-match results are estimates for reference only. Always verify samples with suppliers before placing orders.',
        'Screenshots, sharing, and external messaging features must be used lawfully and respect supplier and third-party rights.',
      ],
    ),
    const LegalSection(
      title: 'Intellectual property',
      paragraphs: [
        'The App, its design, logos, and software are owned by Thredo or its licensors. Product images, videos, trademarks, and descriptions belong to their respective owners and are shown for informational purposes.',
        'You may not copy, modify, distribute, or create derivative works from App content except as allowed by law or with written permission.',
      ],
    ),
    const LegalSection(
      title: 'Third-party services',
      paragraphs: [
        'The App may link to or integrate third-party services (such as WhatsApp, device sharing, or payment tools offered by suppliers). Those services have their own terms and privacy policies; we are not responsible for them.',
        'Your dealings with suppliers are solely between you and the supplier. $_appName is a discovery and engagement platform, not a party to your purchase contracts unless explicitly stated otherwise.',
      ],
    ),
    const LegalSection(
      title: 'Disclaimer',
      paragraphs: [
        'THE APP AND ALL CONTENT ARE PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.',
        'We do not warrant uninterrupted or error-free operation, exact colour reproduction on your screen, or that matching algorithms will meet your production requirements.',
      ],
    ),
    const LegalSection(
      title: 'Limitation of liability',
      paragraphs: [
        'To the maximum extent permitted by law, Thredo and its affiliates shall not be liable for indirect, incidental, special, consequential, or punitive damages, or for loss of profits, data, or business arising from your use of the App or reliance on product information or match results.',
        'Our total liability for any claim relating to the App shall not exceed the greater of (a) amounts you paid us for the App in the twelve months before the claim, or (b) one hundred Indian Rupees (INR 100), if you use a free version of the App.',
      ],
    ),
    const LegalSection(
      title: 'Suspension and termination',
      paragraphs: [
        'You may log out or delete your account at any time from the Profile screen.',
        'We may suspend or terminate access if you breach these Terms, pose a security risk, or as required by law. Provisions that by nature should survive termination will remain in effect.',
      ],
    ),
    const LegalSection(
      title: 'Governing law',
      paragraphs: [
        'These Terms are governed by the laws of India, without regard to conflict-of-law principles. Courts in India shall have exclusive jurisdiction over disputes arising from these Terms, subject to any mandatory consumer protections in your location.',
      ],
    ),
    const LegalSection(
      title: 'Changes',
      paragraphs: [
        'We may modify these Terms from time to time. Material changes will be reflected by updating the "Last updated" date in the App. Your continued use after changes constitutes acceptance.',
      ],
    ),
    const LegalSection(
      title: 'Contact',
      paragraphs: [
        'Questions about these Terms: $_supportEmail (subject line "Terms – $_appName").',
      ],
    ),
  ];
}
