import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';

class BBProgressBar extends StatelessWidget {
  final double value; // 0.0 – 1.0
  final double height;
  const BBProgressBar({super.key, required this.value, this.height = 4});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: LinearProgressIndicator(value: value.clamp(0.0, 1.0), minHeight: height, backgroundColor: AppColors.grey200, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
  );
}

class BBStepBar extends StatelessWidget {
  final int step; final int total;
  const BBStepBar({super.key, required this.step, required this.total});
  @override
  Widget build(BuildContext context) => BBProgressBar(value: step / total);
}

class BBDurationBar extends StatelessWidget {
  final int remaining; final int total;
  const BBDurationBar({super.key, required this.remaining, required this.total});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    BBProgressBar(value: total > 0 ? remaining / total : 0),
    const SizedBox(height: 4),
    Text('$remaining months left', style: T.caption.copyWith(color: AppColors.slate, fontWeight: FontWeight.w500)),
  ]);
}
