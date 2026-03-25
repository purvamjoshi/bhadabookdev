import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'bb_button.dart';

class BBEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const BBEmptyState({super.key, required this.icon, required this.title, required this.desc, this.ctaLabel, this.onCta});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80,
        decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(20)),
        child: Icon(icon, size: 40, color: AppColors.primary)),
      const SizedBox(height: 20),
      Text(title, style: T.h2.copyWith(fontSize: 20), textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Text(desc, style: T.bodySm, textAlign: TextAlign.center),
      if (ctaLabel != null && onCta != null) ...[
        const SizedBox(height: 24),
        BBButton(label: ctaLabel!, onPressed: onCta, fullWidth: false),
      ],
    ])),
  );
}
