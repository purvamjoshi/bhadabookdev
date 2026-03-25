import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().goBack()),
      title: Text('Privacy Policy', style: T.h3),
    ),
    body: SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Privacy Policy', style: T.h2),
      const SizedBox(height: 8),
      Text('Last updated: January 2025', style: T.caption.copyWith(color: AppColors.slate)),
      const SizedBox(height: 20),
      _Section('Information We Collect', 'We collect the information you provide when setting up your account and managing properties: name, phone number, email address, property details, tenant information, and payment records.'),
      _Section('How We Use Your Information', 'Your information is used exclusively to power the features of BhadaBook — managing properties, tracking rent payments, and generating receipts. We do not sell or share your personal data.'),
      _Section('Data Storage', 'Your data is stored securely. We use industry-standard encryption to protect your information in transit and at rest.'),
      _Section('Your Rights', 'You may request deletion of your account and associated data at any time by contacting our support team.'),
      _Section('Contact Us', 'For privacy-related questions, email us at privacy@bhadabook.in'),
    ])),
  );

  static Widget _Section(String title, String body) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
    const SizedBox(height: 4),
    Text(body,  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.slate, height: 1.6)),
  ]));
}
