import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../../../core/widgets/bb_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override State<AccountScreen> createState() => _State();
}

class _State extends State<AccountScreen> {
  final _nameCtrl  = TextEditingController(text: 'Abhinav');
  final _emailCtrl = TextEditingController(text: 'abhinav@example.com');
  String? _nameErr;

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) { setState(() => _nameErr = 'Name required'); return; }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    context.pop();
  }

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      title: Text('Account Details', style: T.h3),
    ),
    body: SingleChildScrollView(padding: S.pageAll, child: Column(children: [
      Center(child: Stack(children: [
        CircleAvatar(radius: 44, backgroundColor: AppColors.primarySurface,
          child: Text('A', style: T.h1.copyWith(color: AppColors.primary, fontSize: 36))),
        Positioned(bottom: 0, right: 0, child: Container(
          width: 28, height: 28,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.camera_alt_outlined, color: AppColors.white, size: 14),
        )),
      ])),
      const SizedBox(height: 20),
      BBCard(child: Column(children: [
        BBTextField(label: 'Full Name *', hint: 'Your name', controller: _nameCtrl, error: _nameErr),
        const SizedBox(height: 12),
        BBTextField(label: 'Email (optional)', hint: 'email@example.com', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 12),
        // Phone — read-only
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey200), borderRadius: BorderRadius.circular(10), color: AppColors.grey100),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mobile Number', style: T.caption.copyWith(color: AppColors.slate, fontSize: 11)),
              const SizedBox(height: 2),
              Text('+91 98765 43210', style: T.bodySm.copyWith(color: AppColors.grey400)),
            ])),
            const Icon(Icons.lock_outline, size: 16, color: AppColors.grey400),
          ]),
        ),
      ])),
      const SizedBox(height: 24),
      BBButton.primary(label: 'SAVE CHANGES', onPressed: _save),
    ])),
  );
}
