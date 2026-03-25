import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../../../core/widgets/bb_empty_state.dart';
import '../../../../core/widgets/bb_shimmer.dart';
import '../../../../core/widgets/bb_smart_tab.dart';
import '../../../../core/widgets/bb_tag.dart';
import '../../../payment/domain/entities/payment.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  @override
  void initState() { super.initState(); context.read<HomeBloc>().add(HomeLoad()); }

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeBloc, HomeState>(builder: (ctx, s) {
    return Scaffold(backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(child: RefreshIndicator(
        onRefresh: () async => ctx.read<HomeBloc>().add(HomeLoad()),
        child: s.loading ? const _Shimmer() : _Body(s: s),
      )),
    );
  });
}

class _Shimmer extends StatelessWidget {
  const _Shimmer();
  @override Widget build(BuildContext context) => Padding(padding: S.pageAll, child: Column(children: const [
    BBShimmer(width: double.infinity, height: 64), SizedBox(height: 12),
    BBShimmer(width: double.infinity, height: 80), SizedBox(height: 12),
    BBListShimmer(count: 4),
  ]));
}

class _Body extends StatelessWidget {
  final HomeState s;
  const _Body({required this.s});

  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: [
    SliverToBoxAdapter(child: _TopBar()),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16,12,16,0), child: _MonthRow(s: s))),
    if (s.isNewUser) SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16,10,16,0), child: _SetupCard())),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16,10,16,0), child: _BreakdownCard(s: s))),
    SliverPersistentHeader(pinned: true, delegate: _StickyHeader(child: Container(color: AppColors.scaffoldBg, padding: const EdgeInsets.symmetric(vertical: 10), child: BBSmartTabBar(
      selected: s.tab, onChanged: (i) => context.read<HomeBloc>().add(HomeTabChange(i)),
      tabs: [BBSmartTab(label: 'All', count: s.all.length), BBSmartTab(label: 'Overdue', count: s.overdue.length, countColor: AppColors.error), BBSmartTab(label: 'Pending', count: s.pending.length, countColor: AppColors.warning), BBSmartTab(label: 'Received', count: s.received.length, countColor: AppColors.success)],
    )))),
    s.current.isEmpty
      ? SliverFillRemaining(child: BBEmptyState(icon: Icons.account_balance_wallet_outlined, title: 'No Payments Yet', desc: 'Your rent transaction history will appear here once payments are recorded.'))
      : SliverPadding(padding: const EdgeInsets.fromLTRB(16,8,16,16), sliver: SliverList(delegate: SliverChildBuilderDelegate(
          (_, i) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _PayCard(p: s.current[i])),
          childCount: s.current.length))),
  ]);
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(color: AppColors.white, padding: const EdgeInsets.fromLTRB(16,12,16,12), child: Row(children: [
    CircleAvatar(radius: 20, backgroundColor: AppColors.primarySurface, child: const Icon(Icons.person, color: AppColors.primary, size: 22)),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Hello,', style: T.caption.copyWith(color: AppColors.slate)),
      Text('Abhinav', style: T.bodyMd.copyWith(fontWeight: FontWeight.w700)),
    ])),
    IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.navy), onPressed: () => context.push('/notifications')),
  ]));
}

class _MonthRow extends StatelessWidget {
  final HomeState s;
  const _MonthRow({required this.s});
  @override Widget build(BuildContext context) => Row(children: [
    Text('Overview', style: T.h2),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () async {
        final p = await showDatePicker(context: context, initialDate: s.month, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDatePickerMode: DatePickerMode.year);
        if (p != null && context.mounted) context.read<HomeBloc>().add(HomeMonthChange(p));
      },
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(Fmt.monthYear(s.month), style: T.bodySmMd.copyWith(color: AppColors.navy)),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.grey400),
      ])),
    ),
  ]);
}

class _SetupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BBCard(child: Row(children: [
    Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.home_outlined, color: AppColors.primary, size: 24)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Complete Property Setup', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
      const SizedBox(height: 2),
      Text('Finish setting up the property to start managing tenants, finance, & more.', style: T.caption.copyWith(height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 6),
      GestureDetector(onTap: () => context.push('/properties/add'), child: Text('CONTINUE SETTING UP →', style: T.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700, letterSpacing: 0.5))),
    ])),
  ]));
}

class _BreakdownCard extends StatelessWidget {
  final HomeState s;
  const _BreakdownCard({required this.s});
  @override Widget build(BuildContext context) => BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Rent Breakdown (₹)', style: T.bodySmMd),
    const SizedBox(height: 12),
    Row(children: [
      _Col(label: 'Total',    value: s.totalPaise > 0    ? Fmt.rupeesStr(s.totalPaise)    : 'N/A', color: AppColors.navy),
      Container(width: 1, height: 32, color: AppColors.divider),
      _Col(label: 'Received', value: s.receivedPaise > 0 ? Fmt.rupeesStr(s.receivedPaise) : 'N/A', color: AppColors.success),
      Container(width: 1, height: 32, color: AppColors.divider),
      _Col(label: 'Pending',  value: s.pendingPaise > 0  ? Fmt.rupeesStr(s.pendingPaise)  : 'N/A', color: AppColors.warning),
    ]),
  ]));
}

class _Col extends StatelessWidget {
  final String label, value; final Color color;
  const _Col({required this.label, required this.value, required this.color});
  @override Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: T.amountSm.copyWith(color: color)),
    const SizedBox(height: 2),
    Text(label, style: T.caption),
  ]));
}

class _PayCard extends StatelessWidget {
  final Payment p;
  const _PayCard({required this.p});
  @override Widget build(BuildContext context) => BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(width: 56, height: 56, color: AppColors.primarySurface, child: const Icon(Icons.apartment, color: AppColors.primary, size: 28))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(p.propertyName ?? '', style: T.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis)), if (p.isOverdue) const BBTag.overdue()]),
        const SizedBox(height: 2),
        Text('Tenant: ${p.tenantName ?? ''}', style: T.caption),
        Text(Fmt.currency(p.amountPaise), style: T.amountSm.copyWith(color: AppColors.primary)),
      ])),
    ]),
    const SizedBox(height: 12),
    if (p.isPaid)
      BBButton.secondary(label: 'VIEW RECEIPT', height: S.btnSmH, onPressed: () => context.push('/receipt', extra: p))
    else
      BBButton.sm(label: 'MARK AS PAID', onPressed: () => context.push('/mark-paid', extra: p)),
  ]));
}

class _StickyHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _StickyHeader({required this.child});
  @override Widget build(_, __, ___) => child;
  @override double get maxExtent => 58;
  @override double get minExtent => 58;
  @override bool shouldRebuild(_) => true;
}
