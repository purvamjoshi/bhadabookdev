import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../../../core/widgets/bb_bottom_sheet.dart';
import '../../../../core/widgets/bb_progress_bar.dart';
import '../../../../core/widgets/bb_smart_tab.dart';
import '../../../../core/widgets/bb_tag.dart';
import '../../../../mock/mock_data.dart';
import '../../../agreement/domain/entities/agreement.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../property/domain/entities/property.dart';
import '../../domain/entities/tenant.dart';

class TenantDetailScreen extends StatefulWidget {
  final String tenantId;
  const TenantDetailScreen({super.key, required this.tenantId});
  @override State<TenantDetailScreen> createState() => _State();
}

class _State extends State<TenantDetailScreen> {
  int _tab = 0;

  Tenant? get _tenant => mockTenants.where((t) => t.id == widget.tenantId).firstOrNull;
  Agreement? get _activeAgr => mockAgreements.where((a) => a.tenantId == widget.tenantId && a.isActive).firstOrNull;
  List<Agreement> get _agreements => mockAgreements.where((a) => a.tenantId == widget.tenantId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  List<Payment> get _payments => mockPayments.where((p) => p.tenantId == widget.tenantId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Widget build(BuildContext context) {
    final tenant = _tenant;
    if (tenant == null) return const Scaffold(body: Center(child: Text('Tenant not found')));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        title: Text(tenant.name, style: T.h3),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(48), child: BBSmartTabBar(
          selected: _tab, onChanged: (i) => setState(() => _tab = i),
          tabs: const [BBSmartTab(label: 'Overview'), BBSmartTab(label: 'Agreements'), BBSmartTab(label: 'Payments')],
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        )),
      ),
      body: switch (_tab) {
        1 => _AgreementsTab(agreements: _agreements, tenantId: widget.tenantId),
        2 => _PaymentsTab(payments: _payments),
        _ => _OverviewTab(tenant: tenant, agr: _activeAgr),
      },
    );
  }
}

// ── Overview tab ─────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final Tenant tenant; final Agreement? agr;
  const _OverviewTab({required this.tenant, this.agr});

  Property? _prop(String? id) => id == null ? null : mockProperties.where((p) => p.id == id).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final prop = _prop(tenant.currentPropertyId);
    return SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Avatar + name
      BBCard(child: Row(children: [
        CircleAvatar(radius: 32, backgroundColor: AppColors.primarySurface,
          child: Text(tenant.initials, style: T.h2.copyWith(color: AppColors.primary))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tenant.name, style: T.bodyMd.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(tenant.phone, style: T.caption.copyWith(color: AppColors.slate)),
          if (prop != null) ...[
            const SizedBox(height: 4),
            Text(prop.name, style: T.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ])),
        IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary), onPressed: () => context.push('/tenants/${tenant.id}/edit')),
      ])),
      const SizedBox(height: 12),

      // Active agreement card
      if (agr != null) ...[
        BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text('Active Agreement', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600))), const BBTag.active()]),
          const SizedBox(height: 10),
          BBDurationBar(remaining: agr!.monthsLeft, total: agr!.totalMonths),
          const SizedBox(height: 10),
          _Row('Monthly Rent', Fmt.currency(agr!.monthlyRentPaise)),
          _Row('Due Date', '${agr!.rentDueDay}th of every month'),
          _Row('End Date', Fmt.date(agr!.endDate)),
          const SizedBox(height: 10),
          BBButton.secondary(
            label: 'EDIT AGREEMENT', height: S.btnSmH,
            onPressed: () => _showEditAgrSheet(context, agr!),
          ),
        ])),
        const SizedBox(height: 12),
      ],

      // Personal info
      BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Personal Details', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        const Divider(height: 16),
        _Row('Permanent Address', tenant.permanentAddress),
        if (tenant.identityProofUrls.isNotEmpty)
          _Row('ID Documents', '${tenant.identityProofUrls.length} uploaded'),
      ])),
    ]));
  }

  Widget _Row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 140, child: Text(l, style: T.caption.copyWith(color: AppColors.slate))),
    Expanded(child: Text(v, style: T.bodySmMd.copyWith(color: AppColors.navy))),
  ]));

  void _showEditAgrSheet(BuildContext ctx, Agreement agr) => BBBottomSheet.show(ctx, title: 'Edit Agreement', children: [
    BBSheetOption(icon: Icons.person_outline, label: 'Edit Tenant Details', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step1', extra: {'agreementId': agr.id, 'edit': true}); }),
    BBSheetOption(icon: Icons.currency_rupee_rounded, label: 'Edit Rent Details', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step2', extra: {'agreementId': agr.id, 'edit': true}); }),
    BBSheetOption(icon: Icons.calendar_today_outlined, label: 'Edit Agreement Dates', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step3', extra: {'agreementId': agr.id, 'edit': true}); }),
  ]);
}

// ── Agreements tab ────────────────────────────────────────────────────────────
class _AgreementsTab extends StatefulWidget {
  final List<Agreement> agreements; final String tenantId;
  const _AgreementsTab({required this.agreements, required this.tenantId});
  @override State<_AgreementsTab> createState() => _AgrTabState();
}
class _AgrTabState extends State<_AgreementsTab> {
  String? _expanded;
  @override Widget build(BuildContext context) {
    final agrs = widget.agreements;
    return SingleChildScrollView(padding: S.pageAll, child: Column(children: [
      ...agrs.asMap().entries.map((e) {
        final i = e.key; final agr = e.value; final expanded = _expanded == agr.id;
        return Padding(padding: const EdgeInsets.only(bottom: 10), child: BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: () => setState(() => _expanded = expanded ? null : agr.id),
            child: Row(children: [
              Expanded(child: Text('Agreement ${agrs.length - i}', style: T.bodyMd)),
              if (agr.isActive) const BBTag.active() else const BBTag.expired(),
              const SizedBox(width: 8),
              Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.grey400),
            ]),
          ),
          if (expanded) ...[
            const Divider(height: 20),
            _AgrRow('Start Date', Fmt.date(agr.startDate)),
            _AgrRow('Move In Date', Fmt.date(agr.moveInDate)),
            _AgrRow('End Date', Fmt.date(agr.endDate)),
            _AgrRow('Monthly Rent', Fmt.currency(agr.monthlyRentPaise)),
            _AgrRow('Security Deposit', Fmt.currency(agr.securityDepositPaise)),
            _AgrRow('Due Day', '${agr.rentDueDay}th of every month'),
          ],
        ])));
      }),
      const SizedBox(height: 12),
      BBButton.secondary(label: 'ADD NEW AGREEMENT +', onPressed: () => context.push('/agreement/step1', extra: {'tenantId': widget.tenantId})),
    ]));
  }
  Widget _AgrRow(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
    SizedBox(width: 130, child: Text(l, style: T.caption.copyWith(color: AppColors.slate))),
    Expanded(child: Text(v, style: T.bodySmMd.copyWith(color: AppColors.navy))),
  ]));
}

// ── Payments tab ──────────────────────────────────────────────────────────────
class _PaymentsTab extends StatelessWidget {
  final List<Payment> payments;
  const _PaymentsTab({required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) return Center(child: Padding(padding: S.pageAll, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.account_balance_wallet_outlined, size: 56, color: AppColors.grey200),
      const SizedBox(height: 12),
      Text('No Payments Yet', style: T.bodyMd.copyWith(color: AppColors.grey400)),
    ])));
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: payments.length,
      itemBuilder: (_, i) {
        final p = payments[i];
        return Padding(padding: const EdgeInsets.only(bottom: 10), child: BBCard(child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(
            color: p.isPaid ? AppColors.successSurface : p.isOverdue ? AppColors.errorSurface : AppColors.warningSurface,
            borderRadius: BorderRadius.circular(10),
          ), child: Icon(
            p.isPaid ? Icons.check_circle_outline : p.isOverdue ? Icons.warning_amber_outlined : Icons.hourglass_empty_rounded,
            color: p.isPaid ? AppColors.success : p.isOverdue ? AppColors.error : AppColors.warning, size: 22,
          )),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(Fmt.currency(p.amountPaise), style: T.bodyMd.copyWith(color: AppColors.navy)),
            Text(p.monthYear, style: T.caption.copyWith(color: AppColors.slate)),
          ])),
          if (p.isPaid)
            const BBTag.paid()
          else if (p.isOverdue)
            const BBTag.overdue()
          else
            const BBTag.pending(),
        ])));
      },
    );
  }
}
