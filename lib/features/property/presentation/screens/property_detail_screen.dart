import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_bottom_sheet.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../../../core/widgets/bb_progress_bar.dart';
import '../../../../core/widgets/bb_smart_tab.dart';
import '../../../../core/widgets/bb_tag.dart';
import '../../../../core/widgets/bb_image_grid.dart';
import '../../../../core/utils/format.dart';
import '../../../../mock/mock_data.dart';
import '../../../agreement/domain/entities/agreement.dart';
import '../../domain/entities/property.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});
  @override State<PropertyDetailScreen> createState() => _State();
}

class _State extends State<PropertyDetailScreen> {
  int _tab = 0;

  Property? get _prop => mockProperties.where((p) => p.id == widget.propertyId).firstOrNull;
  Agreement? get _activeAgr => mockAgreements.where((a) => a.propertyId == widget.propertyId && a.isActive).firstOrNull;
  List<Agreement> get _agreements => mockAgreements.where((a) => a.propertyId == widget.propertyId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Widget build(BuildContext context) {
    final prop = _prop;
    if (prop == null) return const Scaffold(body: Center(child: Text('Property not found')));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        title: Text(prop.name, style: T.h3),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error), onPressed: () => _confirmDelete(context, prop)),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(48), child: BBSmartTabBar(
          selected: _tab, onChanged: (i) => setState(() => _tab = i),
          tabs: const [BBSmartTab(label: 'Overview'), BBSmartTab(label: 'Agreements')],
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        )),
      ),
      body: _tab == 0 ? _Overview(prop: prop, agr: _activeAgr) : _AgreementsTab(agreements: _agreements, propertyId: widget.propertyId),
    );
  }

  void _confirmDelete(BuildContext ctx, Property prop) => showDialog(context: ctx, builder: (_) => AlertDialog(
    title: Text('Delete Property', style: T.h3),
    content: Text('Are you sure you want to delete "${prop.name}"?', style: T.body),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      TextButton(onPressed: () { mockProperties.removeWhere((p) => p.id == prop.id); Navigator.pop(ctx); ctx.pop(); }, child: Text('Delete', style: T.body.copyWith(color: AppColors.error))),
    ],
  ));
}

class _Overview extends StatelessWidget {
  final Property prop; final Agreement? agr;
  const _Overview({required this.prop, this.agr});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    if (agr != null) ...[
      _AgrSummaryCard(agr: agr!, onEdit: () => _showEditAgrSheet(context, agr!)),
      const SizedBox(height: 12),
    ],
    // Property Details card
    BBCard(child: Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Row('Property ID', 'PROP-${prop.id.toUpperCase()}'),
        const Divider(height: 16),
        _Row('Property Name', prop.name),
        _Row('Property Type', prop.categoryLabel),
        _Row('Sub Type', prop.subTypeLabel),
        _Row('What is on Rent', prop.rentUnitLabel),
        if (prop.unitName != null) _Row('Unit', prop.unitName!),
        _Row('Status', ''),
        Row(children: [const SizedBox(width: 0), prop.isVacant ? const BBTag.vacant() : const BBTag.occupied()]),
      ]),
      Positioned(top: 0, right: 0, child: IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary), onPressed: () => context.push('/properties/${prop.id}/edit'))),
    ])),
    const SizedBox(height: 12),
    BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Address', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(prop.address, style: T.bodySm),
      Text(prop.city, style: T.bodySm),
    ])),
    const SizedBox(height: 12),
    BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Property Images', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      BBNetworkImageGrid(urls: prop.imageUrls),
    ])),
  ]));

  Widget _Row(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
    SizedBox(width: 140, child: Text(label, style: T.caption.copyWith(color: AppColors.slate))),
    Expanded(child: Text(value, style: T.bodySmMd.copyWith(color: AppColors.navy))),
  ]));

  void _showEditAgrSheet(BuildContext ctx, Agreement agr) => BBBottomSheet.show(ctx, title: 'Edit Agreement', children: [
    BBSheetOption(icon: Icons.person_outline, label: 'Edit Tenant Details', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step1', extra: {'agreementId': agr.id, 'edit': true}); }),
    BBSheetOption(icon: Icons.currency_rupee_rounded, label: 'Edit Rent Details', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step2', extra: {'agreementId': agr.id, 'edit': true}); }),
    BBSheetOption(icon: Icons.calendar_today_outlined, label: 'Edit Agreement Dates', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step3', extra: {'agreementId': agr.id, 'edit': true}); }),
  ]);
}

class _AgrSummaryCard extends StatelessWidget {
  final Agreement agr; final VoidCallback onEdit;
  const _AgrSummaryCard({required this.agr, required this.onEdit});

  @override
  Widget build(BuildContext context) => BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Expanded(child: Text('Agreement Details', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600))), const BBTag.active()]),
    const SizedBox(height: 10),
    BBDurationBar(remaining: agr.monthsLeft, total: agr.totalMonths),
    const SizedBox(height: 12),
    BBButton.secondary(label: 'EDIT AGREEMENT', height: S.btnSmH, onPressed: onEdit),
  ]));
}

class _AgreementsTab extends StatefulWidget {
  final List<Agreement> agreements; final String propertyId;
  const _AgreementsTab({required this.agreements, required this.propertyId});
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
            _AgrDetail(agr: agr),
          ],
        ])));
      }),
      const SizedBox(height: 12),
      BBButton.secondary(label: 'ADD NEW AGREEMENT +', onPressed: () => _showAddSheet(context)),
    ]));
  }

  void _showAddSheet(BuildContext ctx) => BBBottomSheet.show(ctx, title: 'Add New Agreement', children: [
    BBSheetOption(icon: Icons.person_add_outlined, label: 'Create with New Tenant', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step1', extra: {'propertyId': widget.propertyId}); }),
    BBSheetOption(icon: Icons.people_outline, label: 'Select Existing Tenant', onTap: () { Navigator.pop(ctx); ctx.push('/agreement/step1', extra: {'propertyId': widget.propertyId, 'existing': true}); }),
  ]);
}

class _AgrDetail extends StatelessWidget {
  final Agreement agr;
  const _AgrDetail({required this.agr});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Tenant Details', style: T.bodySmMd.copyWith(fontWeight: FontWeight.w600)),
    const SizedBox(height: 6),
    if (agr.tenantName != null) _Row('Name', agr.tenantName!),
    if (agr.tenantPhone != null) _Row('Contact', agr.tenantPhone!),
    const Divider(height: 16),
    Text('Agreement Details', style: T.bodySmMd.copyWith(fontWeight: FontWeight.w600)),
    const SizedBox(height: 6),
    _Row('Start Date', Fmt.date(agr.startDate)),
    _Row('Move In Date', Fmt.date(agr.moveInDate)),
    _Row('End Date', Fmt.date(agr.endDate)),
    _Row('Rent Amount', Fmt.currency(agr.monthlyRentPaise)),
    _Row('Due Date', '${agr.rentDueDay}th of every month'),
    _Row('Security Deposit', Fmt.currency(agr.securityDepositPaise)),
  ]);
  Widget _Row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [SizedBox(width: 130, child: Text(l, style: T.caption.copyWith(color: AppColors.slate))), Expanded(child: Text(v, style: T.bodySmMd.copyWith(color: AppColors.navy)))]));
}
