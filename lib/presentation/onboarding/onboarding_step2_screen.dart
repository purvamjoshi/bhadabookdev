import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/domain/property/models/property_dto.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_progress_bar.dart';
import 'package:bhadabook/presentation/core/widgets/bb_radio_card.dart';
import 'package:bhadabook/application/onboarding/bloc/onboarding_bloc.dart';

class OnboardingStep2Screen extends StatefulWidget {
  const OnboardingStep2Screen({super.key});
  @override State<OnboardingStep2Screen> createState() => _State();
}

class _State extends State<OnboardingStep2Screen> {
  PropertyCategory? _cat;
  PropertySubType?  _sub;
  RentUnit?         _unit;
  String? _err;

  static const _resSubs = [(PropertySubType.flat,'Flat / Apartment'),(PropertySubType.bungalow,'Bungalow'),(PropertySubType.rowHouse,'Row House'),(PropertySubType.penthouse,'Penthouse'),(PropertySubType.villa,'Villa'),(PropertySubType.chawlRoom,'Chawl Room'),(PropertySubType.pgRoom,'PG / Paying Guest')];
  static const _comSubs = [(PropertySubType.shop,'Shop'),(PropertySubType.officeSpace,'Office Space'),(PropertySubType.warehouse,'Warehouse'),(PropertySubType.showroom,'Showroom'),(PropertySubType.godown,'Godown'),(PropertySubType.factoryUnit,'Factory Unit')];
  static const _units   = [(RentUnit.whole,'Whole Property'),(RentUnit.floor,'Specific Floor'),(RentUnit.room,'Specific Room'),(RentUnit.shopUnit,'Specific Shop Unit')];

  List<(PropertySubType,String)> get _subs => _cat == PropertyCategory.residential ? _resSubs : _comSubs;

  void _next() {
    if (_cat == null || _sub == null || _unit == null) { setState(() => _err = 'Please complete all selections'); return; }
    context.read<OnboardingBloc>().add(OnboardStep2Done(cat: _cat!, sub: _sub!, unit: _unit!));
  }

  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.white,
    appBar: AppBar(backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.onboardStep1)),
      bottom: PreferredSize(preferredSize: const Size.fromHeight(6), child: Padding(padding: S.pageH, child: const BBStepBar(step: 2, total: 3)))),
    body: SafeArea(child: SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Add Property', style: T.h1),
      const SizedBox(height: 6),
      Text('Add a property and manage it with ease.', style: T.bodySm.copyWith(height: 1.6)),
      const SizedBox(height: 28),
      Text('Property Type *', style: T.label),
      const SizedBox(height: 10),
      Row(children: [
        BBRadioCard(label: 'Residential', emoji: '🏠', selected: _cat == PropertyCategory.residential, onTap: () => setState(() { _cat = PropertyCategory.residential; _sub = null; _err = null; })),
        const SizedBox(width: 12),
        BBRadioCard(label: 'Commercial', emoji: '🏢', selected: _cat == PropertyCategory.commercial,  onTap: () => setState(() { _cat = PropertyCategory.commercial;  _sub = null; _err = null; })),
      ]),
      if (_cat != null) ...[
        const SizedBox(height: 22),
        Text('Property Sub Type *', style: T.label),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _subs.map((s) => BBOptionChip(label: s.$2, selected: _sub == s.$1, onTap: () => setState(() { _sub = s.$1; _err = null; }))).toList()),
      ],
      if (_sub != null) ...[
        const SizedBox(height: 22),
        Text('What is on Rent *', style: T.label),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _units.map((u) => BBOptionChip(label: u.$2, selected: _unit == u.$1, onTap: () => setState(() { _unit = u.$1; _err = null; }))).toList()),
      ],
      if (_err != null) ...[const SizedBox(height: 10), Text(_err!, style: T.caption.copyWith(color: AppColors.error))],
      const SizedBox(height: 32),
      Row(children: [
        Expanded(child: BBButton.secondary(label: '← BACK', onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.onboardStep1))),
        const SizedBox(width: 12),
        Expanded(child: BBButton(label: 'NEXT →', onPressed: _next)),
      ]),
      const SizedBox(height: 16),
    ]))),
  );
}
