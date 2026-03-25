import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BBShimmer extends StatefulWidget {
  final double width, height; final BorderRadius? radius;
  const BBShimmer({super.key, required this.width, required this.height, this.radius});
  @override State<BBShimmer> createState() => _BBShimmerState();
}
class _BBShimmerState extends State<BBShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<double> _a;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(); _a = Tween<double>(begin: -2, end: 2).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _a, builder: (_, __) => Container(
    width: widget.width, height: widget.height,
    decoration: BoxDecoration(borderRadius: widget.radius ?? BorderRadius.circular(8),
      gradient: LinearGradient(begin: Alignment(_a.value - 1, 0), end: Alignment(_a.value + 1, 0),
        colors: const [AppColors.grey100, AppColors.grey200, AppColors.grey100])),
  ));
}

class BBCardShimmer extends StatelessWidget {
  const BBCardShimmer({super.key});
  @override Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
    child: Row(children: [
      BBShimmer(width: 64, height: 64, radius: BorderRadius.circular(10)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        BBShimmer(width: double.infinity, height: 14), SizedBox(height: 6),
        BBShimmer(width: 120, height: 12), SizedBox(height: 6),
        BBShimmer(width: 80, height: 12),
      ])),
    ]),
  );
}

class BBListShimmer extends StatelessWidget {
  final int count;
  const BBListShimmer({super.key, this.count = 4});
  @override Widget build(BuildContext context) => Column(children: List.generate(count, (_) => const BBCardShimmer()));
}
