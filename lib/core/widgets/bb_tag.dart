import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum TagVariant { vacant, occupied, overdue, pending, paid, active, expired, info }

class BBTag extends StatelessWidget {
  final String label;
  final TagVariant variant;
  const BBTag(this.label, {super.key, this.variant = TagVariant.info});
  const BBTag.vacant({super.key})   : label = 'Vacant',   variant = TagVariant.vacant;
  const BBTag.occupied({super.key}) : label = 'Occupied', variant = TagVariant.occupied;
  const BBTag.overdue({super.key})  : label = 'Overdue',  variant = TagVariant.overdue;
  const BBTag.pending({super.key})  : label = 'Pending',  variant = TagVariant.pending;
  const BBTag.paid({super.key})     : label = 'Paid',     variant = TagVariant.paid;
  const BBTag.active({super.key})   : label = 'Active',   variant = TagVariant.active;
  const BBTag.expired({super.key})  : label = 'Expired',  variant = TagVariant.expired;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: _fg)),
  );

  Color get _bg { switch (variant) {
    case TagVariant.vacant:   return AppColors.tagVacantBg;
    case TagVariant.occupied: return AppColors.tagOccupiedBg;
    case TagVariant.overdue:  return AppColors.tagOverdueBg;
    case TagVariant.pending:  return AppColors.tagPendingBg;
    case TagVariant.paid:     return AppColors.tagPaidBg;
    case TagVariant.active:   return AppColors.tagOccupiedBg;
    case TagVariant.expired:  return AppColors.grey100;
    case TagVariant.info:     return AppColors.primarySurface;
  }}
  Color get _fg { switch (variant) {
    case TagVariant.vacant:   return AppColors.tagVacantFg;
    case TagVariant.occupied: return AppColors.tagOccupiedFg;
    case TagVariant.overdue:  return AppColors.tagOverdueFg;
    case TagVariant.pending:  return AppColors.tagPendingFg;
    case TagVariant.paid:     return AppColors.tagPaidFg;
    case TagVariant.active:   return AppColors.tagOccupiedFg;
    case TagVariant.expired:  return AppColors.grey500;
    case TagVariant.info:     return AppColors.primary;
  }}
}
