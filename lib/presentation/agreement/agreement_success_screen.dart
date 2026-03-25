import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';

class AgreementSuccessScreen extends StatelessWidget {
  const AgreementSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 100, height: 100,
          decoration: const BoxDecoration(color: AppColors.successSurface, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: AppColors.success, size: 56),
        ),
        const SizedBox(height: 24),
        Text('Agreement Created!', style: T.h2.copyWith(color: AppColors.navy), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'The rental agreement has been created successfully.\nA payment entry has been added for this month.',
          style: T.body.copyWith(color: AppColors.slate),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        BBButton.primary(label: 'GO TO HOME', onPressed: () => navigator<NavigationService>().pushAndRemoveAll(AppRoutes.home)),
        const SizedBox(height: 12),
        BBButton.secondary(label: 'VIEW PROPERTIES', onPressed: () => navigator<NavigationService>().pushAndRemoveAll(AppRoutes.home)),
      ]),
    )),
  );
}
