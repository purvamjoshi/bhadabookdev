import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().goBack()),
      title: Text('Terms of Service', style: T.h3),
    ),
    body: SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Terms of Service', style: T.h2),
      const SizedBox(height: 8),
      Text('Last updated: January 2025', style: T.caption.copyWith(color: AppColors.slate)),
      const SizedBox(height: 20),
      _Section('1. Acceptance of Terms', 'By using BhadaBook, you agree to these terms. BhadaBook is a rent collection and property management application designed for landlords in India.'),
      _Section('2. Use of Service', 'You may use BhadaBook solely for lawful purposes related to property management and rent collection. You are responsible for the accuracy of information you enter.'),
      _Section('3. Data and Privacy', 'We collect and store only the information necessary to provide our service. We do not share your data with third parties without consent.'),
      _Section('4. Limitation of Liability', 'BhadaBook is not liable for any financial loss arising from incorrect data entry or use of the application. Always maintain independent records.'),
      _Section('5. Changes to Terms', 'We may update these terms periodically. Continued use of the app constitutes acceptance of any changes.'),
    ])),
  );

  static Widget _Section(String title, String body) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
    const SizedBox(height: 4),
    Text(body,  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.slate, height: 1.6)),
  ]));
}
