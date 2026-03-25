import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';

class BBSmartTab {
  final String label;
  final int? count;
  final Color? countColor;
  const BBSmartTab({required this.label, this.count, this.countColor});
}

class BBSmartTabBar extends StatelessWidget {
  final List<BBSmartTab> tabs;
  final int selected;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry? padding;

  const BBSmartTabBar({super.key, required this.tabs, required this.selected, required this.onChanged, this.padding});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 38,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: List.generate(tabs.length, (i) {
        final t = tabs[i]; final active = i == selected;
        return Padding(
          padding: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: active ? AppColors.primary : AppColors.grey100, borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(t.label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.w500, color: active ? AppColors.white : AppColors.navy)),
                if ((t.count ?? 0) > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(color: active ? AppColors.white.withOpacity(0.25) : (t.countColor ?? AppColors.error).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Text('${t.count}', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: active ? AppColors.white : (t.countColor ?? AppColors.error))),
                  ),
                ],
              ]),
            ),
          ),
        );
      })),
    ),
  );
}
