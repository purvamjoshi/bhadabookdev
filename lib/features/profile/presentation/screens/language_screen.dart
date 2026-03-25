import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_card.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override State<LanguageScreen> createState() => _State();
}

class _State extends State<LanguageScreen> {
  String _selected = 'en';
  static const _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi',   'native': 'हिंदी'},
    {'code': 'gu', 'name': 'Gujarati','native': 'ગુજરાતી'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      title: Text('Language', style: T.h3),
    ),
    body: Padding(padding: S.pageAll, child: BBCard(child: Column(children:
      _languages.asMap().entries.map((e) {
        final lang   = e.value;
        final isLast = e.key == _languages.length - 1;
        final sel    = _selected == lang['code'];
        return Column(children: [
          InkWell(
            onTap: () { setState(() => _selected = lang['code']!); context.pop(); },
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(lang['name']!,   style: T.bodyMd.copyWith(color: sel ? AppColors.primary : AppColors.navy)),
                Text(lang['native']!, style: T.caption.copyWith(color: AppColors.slate)),
              ])),
              if (sel) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
            ])),
          ),
          if (!isLast) const Divider(height: 8),
        ]);
      }).toList(),
    ))),
  );
}
