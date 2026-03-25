import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../domain/entities/payment.dart';

class RentReceiptScreen extends StatelessWidget {
  final Payment payment;
  const RentReceiptScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      title: Text('Rent Receipt', style: T.h3),
      actions: [IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.primary), onPressed: () {})],
    ),
    body: SingleChildScrollView(padding: S.pageAll, child: Column(children: [
      // Receipt card
      BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(width: 44, height: 44, decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
            child: const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BhadaBook', style: T.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text('Rent Receipt', style: T.caption.copyWith(color: AppColors.slate)),
          ])),
          Text(payment.receiptId, style: T.caption.copyWith(color: AppColors.grey400)),
        ]),
        const Divider(height: 24),

        // Amount
        Center(child: Column(children: [
          Text('Amount Paid', style: T.caption.copyWith(color: AppColors.slate)),
          const SizedBox(height: 4),
          Text(Fmt.currency(payment.amountPaise), style: T.amount.copyWith(color: AppColors.success, fontSize: 36)),
          Text(Fmt.amountInWords(payment.amountPaise), style: T.caption.copyWith(color: AppColors.grey400)),
        ])),
        const Divider(height: 24),

        // Details
        _Row('Receipt ID',   payment.receiptId),
        _Row('Property',     payment.propertyName ?? 'N/A'),
        if (payment.unitName != null) _Row('Unit', payment.unitName!),
        _Row('Tenant',       payment.tenantName   ?? 'N/A'),
        _Row('Month',        payment.monthYear),
        _Row('Payment Mode', _modeLabel(payment.paymentMode)),
        if (payment.paymentDate != null) _Row('Payment Date', Fmt.date(payment.paymentDate!)),
        if (payment.notes != null && payment.notes!.isNotEmpty) _Row('Notes', payment.notes!),
      ])),

      const SizedBox(height: 12),
      // Paid stamp
      Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: AppColors.successSurface, borderRadius: BorderRadius.circular(S.cardR)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success, size: 18),
          const SizedBox(width: 6),
          Text('Payment Verified', style: T.bodySmMd.copyWith(color: AppColors.success)),
        ]),
      ),

      const SizedBox(height: 24),
      BBButton.secondary(label: 'SHARE RECEIPT', onPressed: () {}),
      const SizedBox(height: 24),
    ])),
  );

  Widget _Row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
    SizedBox(width: 120, child: Text(l, style: T.caption.copyWith(color: AppColors.slate))),
    Expanded(child: Text(v, style: T.bodySmMd.copyWith(color: AppColors.navy))),
  ]));

  String _modeLabel(String mode) => const {
    'cash': 'Cash', 'upi': 'UPI', 'bank_transfer': 'Bank Transfer', 'cheque': 'Cheque',
  }[mode] ?? mode;
}
