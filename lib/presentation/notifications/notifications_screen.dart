import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/extensions/format_extension.dart';
import 'package:bhadabook/domain/core/mock/mock_data.dart';
import 'package:bhadabook/domain/notifications/models/notification_dto.dart';
import 'package:bhadabook/presentation/core/widgets/bb_card.dart';
import 'package:bhadabook/presentation/core/widgets/bb_empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override State<NotificationsScreen> createState() => _State();
}

class _State extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifs = mockNotifications;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().goBack()),
        title: Text('Notifications', style: T.h3),
        actions: [
          TextButton(onPressed: () => setState(() { for (final n in mockNotifications) {} }), child: Text('Mark all read', style: T.caption.copyWith(color: AppColors.primary))),
        ],
      ),
      body: notifs.isEmpty
        ? const BBEmptyState(icon: Icons.notifications_none_outlined, title: 'No Notifications', desc: 'You\'re all caught up!')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: notifs.length,
            itemBuilder: (_, i) {
              final n = notifs[i];
              return Padding(padding: const EdgeInsets.only(bottom: 8), child: BBCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: n.read ? AppColors.grey100 : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _iconFor(n.title),
                    color: n.read ? AppColors.grey400 : AppColors.primary, size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(n.title, style: T.bodySmMd.copyWith(color: n.read ? AppColors.grey500 : AppColors.navy))),
                    if (!n.read) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                  ]),
                  const SizedBox(height: 2),
                  Text(n.body, style: T.caption.copyWith(color: AppColors.slate, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(Fmt.relative(n.createdAt), style: T.caption.copyWith(color: AppColors.grey400, fontSize: 11)),
                ])),
              ])));
            },
          ),
    );
  }

  IconData _iconFor(String title) {
    if (title.contains('Rent Due'))      return Icons.calendar_today_outlined;
    if (title.contains('Payment'))       return Icons.account_balance_wallet_outlined;
    if (title.contains('Agreement'))     return Icons.description_outlined;
    if (title.contains('Overdue'))       return Icons.warning_amber_outlined;
    return Icons.notifications_outlined;
  }
}
