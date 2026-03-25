import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';

class BBRadioCard extends StatelessWidget {
  final String label, emoji;
  final bool selected;
  final VoidCallback onTap;
  const BBRadioCard({super.key, required this.label, required this.emoji, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 155, height: 118,
      decoration: BoxDecoration(
        color: selected ? AppColors.primarySurface : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 2 : 1),
      ),
      child: Stack(children: [
        Positioned(top: 10, right: 10, child: AnimatedContainer(
          duration: const Duration(milliseconds: 180), width: 20, height: 20,
          decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? AppColors.primary : AppColors.white, border: Border.all(color: selected ? AppColors.primary : AppColors.grey300, width: selected ? 6 : 2)),
        )),
        Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(label, style: T.bodyMd.copyWith(color: selected ? AppColors.primary : AppColors.navy, fontWeight: FontWeight.w600, fontSize: 15)),
        ])),
      ]),
    ),
  );
}

class BBOptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const BBOptionChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: selected ? AppColors.white : AppColors.navy)),
    ),
  );
}
