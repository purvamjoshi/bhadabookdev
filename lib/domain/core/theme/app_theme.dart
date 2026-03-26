import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, surface: AppColors.scaffoldBg, onPrimary: AppColors.white, error: AppColors.error),
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white, elevation: 0, scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.navy, size: 24),
      titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.navy),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: S.cardR, side: const BorderSide(color: AppColors.border, width: 1)),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, foregroundColor: AppColors.white, elevation: 0,
      minimumSize: const Size(double.infinity, S.btnH),
      shape: RoundedRectangleBorder(borderRadius: S.btnR),
      textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary, width: 1.5),
      minimumSize: const Size(double.infinity, S.btnH),
      shape: RoundedRectangleBorder(borderRadius: S.btnR),
      textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.borderActive, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.borderError, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.borderError, width: 1.5)),
      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 15, color: AppColors.grey400),
      counterText: '',
    ),
    dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.white : AppColors.grey400),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.grey200),
    ),
  );
}
