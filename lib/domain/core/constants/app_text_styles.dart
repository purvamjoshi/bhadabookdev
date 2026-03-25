import 'package:flutter/material.dart';
import 'app_colors.dart';

class T {
  T._();
  static const String _f = 'Poppins'; // fallback to system font

  static const TextStyle h1 = TextStyle(fontFamily: _f, fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy, height: 1.25, letterSpacing: -0.3);
  static const TextStyle h2 = TextStyle(fontFamily: _f, fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.navy, height: 1.3);
  static const TextStyle h3 = TextStyle(fontFamily: _f, fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.navy, height: 1.4);
  static const TextStyle bodyLg = TextStyle(fontFamily: _f, fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.navy);
  static const TextStyle body = TextStyle(fontFamily: _f, fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.navy, height: 1.5);
  static const TextStyle bodyMd = TextStyle(fontFamily: _f, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.navy);
  static const TextStyle bodySm = TextStyle(fontFamily: _f, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.slate, height: 1.5);
  static const TextStyle bodySmMd = TextStyle(fontFamily: _f, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.slate);
  static const TextStyle caption = TextStyle(fontFamily: _f, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.grey400, height: 1.4);
  static const TextStyle capMd = TextStyle(fontFamily: _f, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.grey400);
  static const TextStyle btn = TextStyle(fontFamily: _f, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.2);
  static const TextStyle btnSm = TextStyle(fontFamily: _f, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2);
  static const TextStyle label = TextStyle(fontFamily: _f, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grey500);
  static const TextStyle amount = TextStyle(fontFamily: _f, fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy);
  static const TextStyle amountSm = TextStyle(fontFamily: _f, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.navy);
}
