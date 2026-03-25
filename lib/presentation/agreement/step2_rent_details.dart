import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_card.dart';
import 'package:bhadabook/presentation/core/widgets/bb_progress_bar.dart';
import 'package:bhadabook/presentation/core/widgets/bb_radio_card.dart' show BBOptionChip;
import 'package:bhadabook/presentation/core/widgets/bb_text_field.dart';
import 'package:bhadabook/presentation/agreement/bloc/agreement_bloc.dart';

class AgreementStep2Screen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const AgreementStep2Screen({super.key, required this.extra});
  @override State<AgreementStep2Screen> createState() => _State();
}

class _State extends State<AgreementStep2Screen> {
  final _rentCtrl    = TextEditingController();
  final _depositCtrl = TextEditingController();
  final _dueDayCtrl  = TextEditingController(text: '5');
  String _paymentMode = 'cash';
  String? _rentErr, _depositErr, _dueDayErr;
  bool _initialized = false;

  static const _modes = [
    {'value': 'cash',          'label': 'Cash',         'icon': '💵'},
    {'value': 'upi',           'label': 'UPI',          'icon': '📲'},
    {'value': 'bank_transfer', 'label': 'Bank Transfer', 'icon': '🏦'},
    {'value': 'cheque',        'label': 'Cheque',       'icon': '📋'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final draft = context.read<AgreementBloc>().state.draft;
      if (draft.monthlyRentPaise != null) {
        _rentCtrl.text    = (draft.monthlyRentPaise! ~/ 100).toString();
        _depositCtrl.text = (draft.securityDepositPaise! ~/ 100).toString();
        _dueDayCtrl.text  = draft.rentDueDay?.toString() ?? '5';
        _paymentMode      = draft.paymentMode ?? 'cash';
      }
    }
  }

  bool _validate() {
    final rent    = int.tryParse(_rentCtrl.text.trim());
    final deposit = int.tryParse(_depositCtrl.text.trim());
    final dueDay  = int.tryParse(_dueDayCtrl.text.trim());
    setState(() {
      _rentErr    = rent == null || rent <= 0         ? 'Enter valid rent amount'    : null;
      _depositErr = deposit == null || deposit < 0    ? 'Enter valid deposit amount' : null;
      _dueDayErr  = dueDay == null || dueDay < 1 || dueDay > 28 ? 'Enter day between 1–28' : null;
    });
    return _rentErr == null && _depositErr == null && _dueDayErr == null;
  }

  void _next() {
    if (!_validate()) return;
    context.read<AgreementBloc>().add(AgreementStep2Done(
      rentPaise:    int.parse(_rentCtrl.text.trim()) * 100,
      depositPaise: int.parse(_depositCtrl.text.trim()) * 100,
      dueDay:       int.parse(_dueDayCtrl.text.trim()),
      mode:         _paymentMode,
    ));
    navigator<NavigationService>().navigateTo(AppRoutes.agreementStep3, arguments: widget.extra);
  }

  @override
  void dispose() { _rentCtrl.dispose(); _depositCtrl.dispose(); _dueDayCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra['edit'] == true;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().goBack()),
        title: Text(isEdit ? 'Edit Agreement' : 'New Agreement', style: T.h3),
      ),
      body: SingleChildScrollView(
        padding: S.pageAll,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!isEdit) ...[BBStepBar(step: 2, total: 3), const SizedBox(height: 20)],
          Text('Rent Details', style: T.h3),
          const SizedBox(height: 4),
          Text('Set the rent, deposit, and payment details', style: T.caption.copyWith(color: AppColors.slate)),
          const SizedBox(height: 16),

          BBCard(child: Column(children: [
            BBTextField(
              label: 'Monthly Rent (₹) *', hint: 'e.g. 15000',
              controller: _rentCtrl, error: _rentErr, keyboard: TextInputType.number,
            ),
            const SizedBox(height: 12),
            BBTextField(
              label: 'Security Deposit (₹)', hint: 'e.g. 30000',
              controller: _depositCtrl, error: _depositErr, keyboard: TextInputType.number,
            ),
            const SizedBox(height: 12),
            BBTextField(
              label: 'Rent Due Day *', hint: '1-28 (day of month)',
              controller: _dueDayCtrl, error: _dueDayErr, keyboard: TextInputType.number, maxLen: 2,
            ),
          ])),

          const SizedBox(height: 16),
          Text('Payment Mode', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: _modes.map((m) => BBOptionChip(
            label: '${m['icon']} ${m['label']}',
            selected: _paymentMode == m['value'],
            onTap: () => setState(() => _paymentMode = m['value']!),
          )).toList()),

          const SizedBox(height: 24),
          BBButton.primary(label: 'NEXT: AGREEMENT DATES →', onPressed: _next),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
