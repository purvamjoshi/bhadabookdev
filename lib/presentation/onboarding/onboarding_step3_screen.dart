import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_image_grid.dart';
import 'package:bhadabook/presentation/core/widgets/bb_progress_bar.dart';
import 'package:bhadabook/presentation/core/widgets/bb_text_field.dart';
import 'package:bhadabook/presentation/core/widgets/bb_bottom_sheet.dart';
import 'package:bhadabook/presentation/onboarding/bloc/onboarding_bloc.dart';

class OnboardingStep3Screen extends StatefulWidget {
  const OnboardingStep3Screen({super.key});
  @override State<OnboardingStep3Screen> createState() => _State();
}

class _State extends State<OnboardingStep3Screen> {
  final _name    = TextEditingController();
  final _addr    = TextEditingController();
  final _city    = TextEditingController();
  final _images  = <File>[];
  String? _err;

  @override void dispose() { _name.dispose(); _addr.dispose(); _city.dispose(); super.dispose(); }

  void _addImg() => showImagePicker(context,
    onCamera: () async { final f = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80); if (f != null && mounted) setState(() => _images.add(File(f.path))); },
    onGallery: () async { final fs = await ImagePicker().pickMultiImage(imageQuality: 80); if (fs.isNotEmpty && mounted) setState(() => _images.addAll(fs.map((f) => File(f.path)))); },
  );

  void _complete() {
    if (_name.text.trim().isEmpty || _addr.text.trim().isEmpty || _city.text.trim().isEmpty) { setState(() => _err = 'Please fill all required fields'); return; }
    context.read<OnboardingBloc>().add(OnboardStep3Done(propName: _name.text.trim(), address: _addr.text.trim(), city: _city.text.trim()));
  }

  @override
  Widget build(BuildContext context) => BlocListener<OnboardingBloc, OnboardingState>(
    listener: (ctx, s) {
      if (s is OnboardError) setState(() => _err = s.msg);
    },
    child: Scaffold(backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.onboardStep2)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(6), child: Padding(padding: S.pageH, child: const BBStepBar(step: 3, total: 3)))),
      body: SafeArea(child: SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add Property', style: T.h1),
        const SizedBox(height: 6),
        Text('Add a property and manage it with ease.', style: T.bodySm.copyWith(height: 1.6)),
        const SizedBox(height: 28),
        BBTextField(label: 'Property Name *', hint: 'e.g. Greenview Residency', controller: _name, onChange: (_) => setState(() => _err = null)),
        const SizedBox(height: 16),
        BBTextField(label: 'Full Address *', hint: 'Enter complete property address', controller: _addr, maxLines: 3, keyboard: TextInputType.streetAddress),
        const SizedBox(height: 16),
        BBTextField(label: 'City *', hint: 'e.g. Ahmedabad', controller: _city),
        const SizedBox(height: 20),
        Text('Property Images', style: T.label),
        const SizedBox(height: 8),
        BBImageGrid(images: _images, onAdd: _addImg, onRemove: (i) => setState(() => _images.removeAt(i))),
        if (_err != null) ...[const SizedBox(height: 10), Text(_err!, style: T.caption.copyWith(color: AppColors.error))],
        const SizedBox(height: 32),
        Row(children: [
          Expanded(child: BBButton.secondary(label: '← BACK', onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.onboardStep2))),
          const SizedBox(width: 12),
          Expanded(child: BlocBuilder<OnboardingBloc, OnboardingState>(builder: (_, s) => BBButton(label: 'COMPLETE SETUP', isLoading: s is OnboardLoading, onPressed: _complete))),
        ]),
        const SizedBox(height: 16),
      ]))),
    ),
  );
}
