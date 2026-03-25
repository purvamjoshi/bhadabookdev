import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    body: SafeArea(child: SingleChildScrollView(child: Column(children: [
      // Header
      Container(color: AppColors.white, padding: const EdgeInsets.fromLTRB(16, 20, 16, 20), child: Row(children: [
        CircleAvatar(radius: 28, backgroundColor: AppColors.primarySurface,
          child: Text('A', style: T.h2.copyWith(color: AppColors.primary))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Abhinav', style: T.bodyMd.copyWith(fontWeight: FontWeight.w700)),
          Text('+91 98765 43210', style: T.caption.copyWith(color: AppColors.slate)),
        ])),
        IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20), onPressed: () => context.push('/profile/account')),
      ])),
      const SizedBox(height: 8),

      // Menu groups
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: Column(children: [
        _Section(title: 'Account', items: [
          _Item(icon: Icons.person_outline,      label: 'Account Details',        onTap: () => context.push('/profile/account')),
          _Item(icon: Icons.language_outlined,   label: 'Language',               onTap: () => context.push('/profile/language')),
          _Item(icon: Icons.notifications_outlined, label: 'Notification Settings', onTap: () => context.push('/profile/notification-settings')),
        ]),
        const SizedBox(height: 12),
        _Section(title: 'Support & Legal', items: [
          _Item(icon: Icons.help_outline,        label: 'Help & Support',         onTap: () {}),
          _Item(icon: Icons.description_outlined, label: 'Terms of Service',      onTap: () => context.push('/profile/terms')),
          _Item(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy',        onTap: () => context.push('/profile/privacy')),
          _Item(icon: Icons.star_border_outlined, label: 'Rate the App',          onTap: () {}),
        ]),
        const SizedBox(height: 12),
        BBCard(child: InkWell(
          onTap: () => _confirmLogout(context),
          borderRadius: BorderRadius.circular(S.cardR),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            Container(width: 36, height: 36, decoration: const BoxDecoration(color: AppColors.errorSurface, shape: BoxShape.circle),
              child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18)),
            const SizedBox(width: 12),
            Text('Sign Out', style: T.bodyMd.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
          ])),
        )),
        const SizedBox(height: 24),
        Text('BhadaBook v1.0.0', style: T.caption.copyWith(color: AppColors.grey400)),
        const SizedBox(height: 24),
      ])),
    ]))),
  );

  void _confirmLogout(BuildContext ctx) => showDialog(context: ctx, builder: (_) => AlertDialog(
    title: Text('Sign Out', style: T.h3),
    content: Text('Are you sure you want to sign out?', style: T.body),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      TextButton(onPressed: () { Navigator.pop(ctx); ctx.go('/'); }, child: Text('Sign Out', style: T.body.copyWith(color: AppColors.error))),
    ],
  ));
}

class _Section extends StatelessWidget {
  final String title; final List<_Item> items;
  const _Section({required this.title, required this.items});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: T.caption.copyWith(color: AppColors.slate, fontWeight: FontWeight.w600, letterSpacing: 0.5))),
    BBCard(child: Column(children: items.asMap().entries.map((e) {
      final isLast = e.key == items.length - 1;
      return Column(children: [
        InkWell(
          onTap: e.value.onTap,
          borderRadius: BorderRadius.circular(S.cardR),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)),
              child: Icon(e.value.icon, color: AppColors.navy, size: 18)),
            const SizedBox(width: 12),
            Expanded(child: Text(e.value.label, style: T.bodyMd)),
            const Icon(Icons.chevron_right_rounded, color: AppColors.grey400, size: 20),
          ])),
        ),
        if (!isLast) const Divider(height: 1),
      ]);
    }).toList())),
  ]);
}

class _Item { final IconData icon; final String label; final VoidCallback onTap; const _Item({required this.icon, required this.label, required this.onTap}); }
