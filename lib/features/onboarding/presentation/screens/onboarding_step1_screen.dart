import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_progress_bar.dart';
import '../../../../core/widgets/bb_text_field.dart';
import '../../../../core/widgets/bb_radio_card.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingStep1Screen extends StatefulWidget {
  const OnboardingStep1Screen({super.key});
  @override State<OnboardingStep1Screen> createState() => _State();
}

class _State extends State<OnboardingStep1Screen> {
  final _name  = TextEditingController();
  final _email = TextEditingController();
  String _lang = 'en';
  String? _nameErr;

  static const _langs = [('en','English'),('hi','Hindi'),('gu','Gujarati'),('mr','Marathi')];

  @override void dispose() { _name.dispose(); _email.dispose(); super.dispose(); }

  void _next() {
    if (_name.text.trim().isEmpty) { setState(() => _nameErr = 'Full name is required'); return; }
    context.read<OnboardingBloc>().add(OnboardStep1Done(name: _name.text.trim(), email: _email.text.trim().isEmpty ? null : _email.text.trim(), lang: _lang));
  }

  @override
  Widget build(BuildContext context) => BlocListener<OnboardingBloc, OnboardingState>(
    listener: (ctx, s) { if (s is OnboardStep1) ctx.go('/onboarding/step2'); },
    child: Scaffold(backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, automaticallyImplyLeading: false, elevation: 0,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(6), child: Padding(padding: S.pageH, child: const BBStepBar(step: 1, total: 3)))),
      body: SafeArea(child: SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Basic Details', style: T.h1),
        const SizedBox(height: 6),
        Text('Add a few details to set up your profile.', style: T.bodySm.copyWith(height: 1.6)),
        const SizedBox(height: 28),
        // Profile photo
        Center(child: GestureDetector(
          onTap: () {},
          child: Stack(children: [
            CircleAvatar(radius: 44, backgroundColor: AppColors.primarySurface, child: const Icon(Icons.person, size: 44, color: AppColors.primary)),
            Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28,
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: AppColors.white, width: 2)),
              child: const Icon(Icons.camera_alt, size: 14, color: AppColors.white))),
          ]),
        )),
        const SizedBox(height: 24),
        BBTextField(label: 'Full Name *', hint: 'e.g. Abhinav Singh', controller: _name, error: _nameErr, onChange: (_) => setState(() => _nameErr = null)),
        const SizedBox(height: 16),
        BBTextField(label: 'Email (Optional)', hint: 'e.g. abhinav@email.com', controller: _email, keyboard: TextInputType.emailAddress),
        const SizedBox(height: 16),
        Text('Preferred Language', style: T.label),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _langs.map((l) => BBOptionChip(label: l.$2, selected: _lang == l.$1, onTap: () => setState(() => _lang = l.$1))).toList()),
        const SizedBox(height: 32),
        BBButton(label: 'NEXT →', onPressed: _next),
        const SizedBox(height: 16),
      ]))),
    ),
  );
}
