import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';

class BBBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const BBBottomSheet({super.key, required this.title, required this.children});

  static Future<T?> show<T>(BuildContext ctx, {required String title, required List<Widget> children, bool dismissible = true}) =>
      showModalBottomSheet<T>(context: ctx, isDismissible: dismissible, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (_) => BBBottomSheet(title: title, children: children));

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 12),
      Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2))),
      Padding(padding: const EdgeInsets.fromLTRB(16, 14, 8, 8), child: Row(children: [
        Expanded(child: Text(title, style: T.h3)),
        IconButton(icon: const Icon(Icons.close, color: AppColors.grey400), onPressed: () => Navigator.pop(context)),
      ])),
      const Divider(height: 1),
      ...children,
      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
    ]),
  );
}

class BBSheetOption extends StatelessWidget {
  final IconData icon; final String label; final String? subtitle; final VoidCallback onTap; final Color? iconBg;
  const BBSheetOption({super.key, required this.icon, required this.label, this.subtitle, required this.onTap, this.iconBg});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: iconBg ?? AppColors.primarySurface, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 22)),
    title: Text(label, style: T.bodyMd),
    subtitle: subtitle != null ? Text(subtitle!, style: T.bodySm) : null,
    trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
    onTap: onTap,
  );
}

Future<void> showImagePicker(BuildContext ctx, {required VoidCallback onCamera, required VoidCallback onGallery}) =>
    BBBottomSheet.show(ctx, title: 'Upload Image', children: [
      BBSheetOption(icon: Icons.camera_alt_outlined, label: 'Take Photo', onTap: () { Navigator.pop(ctx); onCamera(); }),
      BBSheetOption(icon: Icons.photo_library_outlined, label: 'Choose Photo', onTap: () { Navigator.pop(ctx); onGallery(); }),
    ]);
