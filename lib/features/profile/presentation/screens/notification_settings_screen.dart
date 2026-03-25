import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_card.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override State<NotificationSettingsScreen> createState() => _State();
}

class _State extends State<NotificationSettingsScreen> {
  bool _rentDue = true, _overdue = true, _expiryAlert = true, _paymentReceived = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      title: Text('Notification Settings', style: T.h3),
    ),
    body: Padding(padding: S.pageAll, child: BBCard(child: Column(children: [
      _Toggle('Rent Due Reminders',      'Get notified 3 days before rent due date', _rentDue,         (v) => setState(() => _rentDue = v)),
      const Divider(height: 8),
      _Toggle('Overdue Alerts',          'Alert when rent becomes overdue',          _overdue,         (v) => setState(() => _overdue = v)),
      const Divider(height: 8),
      _Toggle('Agreement Expiry Alerts', 'Alert 30 days before agreement expires',   _expiryAlert,     (v) => setState(() => _expiryAlert = v)),
      const Divider(height: 8),
      _Toggle('Payment Received',        'Confirm when payment is recorded',         _paymentReceived, (v) => setState(() => _paymentReceived = v)),
    ]))),
  );

  Widget _Toggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) =>
    Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: T.bodyMd),
        Text(subtitle, style: T.caption.copyWith(color: AppColors.slate)),
      ])),
      Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    ]));
}
