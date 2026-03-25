import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class BBAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget? bottom;
  final double bottomHeight;
  final PreferredSizeWidget? preferredBottom;

  const BBAppBar({super.key, required this.title, this.showBack = true, this.actions, this.backgroundColor, this.bottom, this.bottomHeight = 0, this.preferredBottom});

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: backgroundColor ?? AppColors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: showBack,
    leading: showBack ? IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)) : null,
    title: Text(title, style: T.h3),
    actions: actions,
    bottom: preferredBottom,
  );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (preferredBottom?.preferredSize.height ?? 0));
}
