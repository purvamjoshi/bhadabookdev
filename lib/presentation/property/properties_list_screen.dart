import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/domain/core/mock/mock_data.dart';
import 'package:bhadabook/domain/agreement/models/agreement_dto.dart';
import 'package:bhadabook/domain/property/models/property_dto.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_card.dart';
import 'package:bhadabook/presentation/core/widgets/bb_empty_state.dart';
import 'package:bhadabook/presentation/core/widgets/bb_shimmer.dart';
import 'package:bhadabook/presentation/core/widgets/bb_smart_tab.dart';
import 'package:bhadabook/presentation/core/widgets/bb_tag.dart';
import 'package:bhadabook/presentation/core/widgets/bb_progress_bar.dart';
import 'package:bhadabook/application/property/bloc/property_bloc.dart';

class PropertiesListScreen extends StatefulWidget {
  const PropertiesListScreen({super.key});
  @override State<PropertiesListScreen> createState() => _State();
}

class _State extends State<PropertiesListScreen> {
  @override void initState() { super.initState(); context.read<PropertyBloc>().add(PropertyLoad()); }

  @override
  Widget build(BuildContext context) => BlocBuilder<PropertyBloc, PropertyState>(builder: (ctx, s) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    body: SafeArea(child: Column(children: [
      // Header
      Container(color: AppColors.white, padding: const EdgeInsets.fromLTRB(16,16,16,12), child: Row(children: [
        Expanded(child: Text('Properties (${mockProperties.length})', style: T.h2)),
        BBButton.sm(label: 'Add Property', icon: Icons.add, fullWidth: false, onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.addProperty)),
      ])),
      const SizedBox(height: 10),
      BBSmartTabBar(selected: s.tab, onChanged: (i) => ctx.read<PropertyBloc>().add(PropertyTabChange(i)),
        tabs: [BBSmartTab(label: 'Vacant', count: s.vacant.length), BBSmartTab(label: 'Occupied', count: s.occupied.length, countColor: AppColors.success)]),
      const SizedBox(height: 8),
      Expanded(child: s.loading
        ? const Padding(padding: S.pageAll, child: BBListShimmer())
        : s.current.isEmpty
          ? BBEmptyState(icon: Icons.apartment_outlined, title: 'No Properties Yet', desc: 'Add your first property to start tracking rent and managing tenants.', ctaLabel: 'Add Property', onCta: () => navigator<NavigationService>().navigateTo(AppRoutes.addProperty))
          : ListView.builder(padding: const EdgeInsets.fromLTRB(16, 4, 16, 16), itemCount: s.current.length, itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _PropCard(p: s.current[i], isOccupied: s.tab == 1)))),
    ])),
  ));
}

class _PropCard extends StatelessWidget {
  final Property p; final bool isOccupied;
  const _PropCard({required this.p, required this.isOccupied});

  Agreement? get _agr => isOccupied ? mockAgreements.where((a) => a.propertyId == p.id && a.isActive).firstOrNull : null;

  @override
  Widget build(BuildContext context) => BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(width: 64, height: 64, color: AppColors.primarySurface, child: const Icon(Icons.apartment, color: AppColors.primary, size: 32))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (p.unitName != null) Text('Unit: ${p.unitName}', style: T.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        Text(p.name, style: T.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(p.address, style: T.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Wrap(spacing: 6, children: [
          BBTag(p.categoryLabel), BBTag(p.subTypeLabel),
          if (!isOccupied) const BBTag.vacant() else const BBTag.occupied(),
        ]),
      ])),
    ]),
    if (isOccupied && _agr != null) ...[
      const SizedBox(height: 10),
      BBDurationBar(remaining: _agr!.monthsLeft, total: _agr!.totalMonths),
    ],
    const SizedBox(height: 12),
    if (!isOccupied)
      BBButton.secondary(label: 'ADD AGREEMENT', height: S.btnSmH, onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.agreementStep1, arguments: {'propertyId': p.id}))
    else
      const SizedBox.shrink(),
    const SizedBox(height: 8),
    GestureDetector(
      onTap: () => navigator<NavigationService>().navigateTo(AppRoutes.propertyDetail, arguments: p.id),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text('VIEW DETAILS', style: T.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
        const SizedBox(width: 2),
        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
      ]),
    ),
  ]));
}
