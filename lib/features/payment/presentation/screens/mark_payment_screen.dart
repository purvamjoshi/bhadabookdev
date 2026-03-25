import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../../../core/widgets/bb_radio_card.dart' show BBOptionChip;
import '../../../../core/widgets/bb_text_field.dart';
import '../../domain/entities/payment.dart';
import '../bloc/payment_bloc.dart';

class MarkPaymentScreen extends StatefulWidget {
  final Payment payment;
  const MarkPaymentScreen({super.key, required this.payment});
  @override State<MarkPaymentScreen> createState() => _State();
}

class _State extends State<MarkPaymentScreen> {
  String _mode = 'cash';
  final _notesCtrl = TextEditingController();

  static const _modes = [
    {'value': 'cash',          'label': 'Cash',          'icon': '💵'},
    {'value': 'upi',           'label': 'UPI',           'icon': '📲'},
    {'value': 'bank_transfer', 'label': 'Bank Transfer',  'icon': '🏦'},
    {'value': 'cheque',        'label': 'Cheque',        'icon': '📋'},
  ];

  void _submit() {
    context.read<PaymentBloc>().add(PaymentMarkPaid(
      paymentId:   widget.payment.id,
      paymentMode: _mode,
      notes:       _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    ));
  }

  @override
  void dispose() { _notesCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => BlocListener<PaymentBloc, PaymentState>(
    listener: (ctx, s) {
      if (s.success) context.go('/home');
    },
    child: Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        title: Text('Mark as Paid', style: T.h3),
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(builder: (_, s) => SingleChildScrollView(
        padding: S.pageAll,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Payment summary card
          BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payment Summary', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            const Divider(height: 16),
            _Row('Property', widget.payment.propertyName ?? 'N/A'),
            if (widget.payment.unitName != null) _Row('Unit', widget.payment.unitName!),
            _Row('Tenant', widget.payment.tenantName ?? 'N/A'),
            _Row('Amount', Fmt.currency(widget.payment.amountPaise)),
            _Row('Month', widget.payment.monthYear),
          ])),
          const SizedBox(height: 16),

          Text('Payment Mode', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: _modes.map((m) => BBOptionChip(
            label: '${m['icon']} ${m['label']}',
            selected: _mode == m['value'],
            onTap: () => setState(() => _mode = m['value']!),
          )).toList()),
          const SizedBox(height: 16),
          BBTextField(label: 'Notes (optional)', hint: 'e.g. UPI ref: 123456', controller: _notesCtrl, maxLines: 2),

          const SizedBox(height: 24),
          BBButton.primary(
            label: 'CONFIRM PAYMENT',
            onPressed: s.saving ? null : _submit,
            isLoading: s.saving,
          ),
          const SizedBox(height: 24),
        ]),
      )),
    ),
  );

  Widget _Row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
    SizedBox(width: 100, child: Text(l, style: T.caption.copyWith(color: AppColors.slate))),
    Expanded(child: Text(v, style: T.bodySmMd.copyWith(color: AppColors.navy))),
  ]));
}
