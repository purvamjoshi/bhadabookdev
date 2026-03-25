import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/domain/core/mock/mock_data.dart';
import 'package:bhadabook/domain/tenant/models/tenant_dto.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_card.dart';
import 'package:bhadabook/presentation/core/widgets/bb_empty_state.dart';
import 'package:bhadabook/presentation/core/widgets/bb_shimmer.dart';
import 'package:bhadabook/application/tenant/bloc/tenant_bloc.dart';

class TenantsListScreen extends StatefulWidget {
  const TenantsListScreen({super.key});
  @override State<TenantsListScreen> createState() => _State();
}

class _State extends State<TenantsListScreen> {
  @override void initState() { super.initState(); context.read<TenantBloc>().add(TenantLoad()); }

  @override
  Widget build(BuildContext context) => BlocBuilder<TenantBloc, TenantState>(builder: (ctx, s) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    body: SafeArea(child: Column(children: [
      Container(color: AppColors.white, padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), child: Row(children: [
        Expanded(child: Text('Tenants (${mockTenants.length})', style: T.h2)),
        BBButton.sm(label: 'Add Tenant', icon: Icons.add, fullWidth: false, onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.addTenant)),
      ])),
      const SizedBox(height: 8),
      Expanded(child: s.loading
        ? const Padding(padding: S.pageAll, child: BBListShimmer())
        : s.tenants.isEmpty
          ? BBEmptyState(icon: Icons.people_outline, title: 'No Tenants Yet', desc: 'Your tenants will appear here once added.', ctaLabel: 'Add Tenant', onCta: () => navigator<NavigationService>().navigateTo(AppRoutes.addTenant))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: s.tenants.length,
              itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _TenantCard(tenant: s.tenants[i])),
            )),
    ])),
  ));
}

class _TenantCard extends StatelessWidget {
  final Tenant tenant;
  const _TenantCard({required this.tenant});

  String get _propertyName {
    if (tenant.currentPropertyId == null) return 'No active property';
    final p = mockProperties.where((p) => p.id == tenant.currentPropertyId).firstOrNull;
    return p?.name ?? 'Unknown Property';
  }

  @override
  Widget build(BuildContext context) => BBCard(child: Row(children: [
    CircleAvatar(radius: 24, backgroundColor: AppColors.primarySurface,
      child: Text(tenant.initials, style: T.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tenant.name, style: T.bodyMd),
      const SizedBox(height: 2),
      Text(tenant.phone, style: T.caption.copyWith(color: AppColors.slate)),
      const SizedBox(height: 2),
      Text(_propertyName, style: T.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
    ])),
    IconButton(
      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.grey400),
      onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.tenantDetail, arguments: tenant.id),
    ),
  ]));
}
