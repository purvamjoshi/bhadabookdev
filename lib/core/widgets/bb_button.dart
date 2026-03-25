import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum BtnVariant { primary, secondary, ghost, danger }

class BBButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BtnVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final IconData? icon;
  final double fontSize;

  const BBButton({super.key, required this.label, this.onPressed, this.variant = BtnVariant.primary, this.isLoading = false, this.fullWidth = true, this.height = S.btnH, this.icon, this.fontSize = 16});
  const BBButton.secondary({super.key, required this.label, this.onPressed, this.isLoading = false, this.fullWidth = true, this.height = S.btnH, this.icon, this.fontSize = 16}) : variant = BtnVariant.secondary;
  const BBButton.ghost({super.key, required this.label, this.onPressed, this.isLoading = false, this.fullWidth = false, this.height = 36, this.icon, this.fontSize = 14}) : variant = BtnVariant.ghost;
  const BBButton.danger({super.key, required this.label, this.onPressed, this.isLoading = false, this.fullWidth = true, this.height = S.btnH, this.icon, this.fontSize = 16}) : variant = BtnVariant.danger;
  const BBButton.primary({super.key, required this.label, this.onPressed, this.isLoading = false, this.fullWidth = true, this.height = S.btnH, this.icon, this.fontSize = 16}) : variant = BtnVariant.primary;
  const BBButton.sm({super.key, required this.label, this.onPressed, this.variant = BtnVariant.primary, this.isLoading = false, this.fullWidth = true, this.icon, this.fontSize = 14}) : height = S.btnSmH;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: variant == BtnVariant.primary ? AppColors.white : AppColors.primary))
        : Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
            Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: fontSize, fontWeight: FontWeight.w600, color: _fg, letterSpacing: 0.2)),
          ]);

    final size = Size(fullWidth ? double.infinity : 0, height);
    final shape = RoundedRectangleBorder(borderRadius: S.btnR);

    switch (variant) {
      case BtnVariant.primary:
        return SizedBox(height: height, width: fullWidth ? double.infinity : null,
          child: ElevatedButton(onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: onPressed == null && !isLoading ? AppColors.grey200 : AppColors.primary, foregroundColor: AppColors.white, elevation: 0, minimumSize: size, shape: shape, padding: const EdgeInsets.symmetric(horizontal: 20)),
            child: child));
      case BtnVariant.secondary:
        return SizedBox(height: height, width: fullWidth ? double.infinity : null,
          child: OutlinedButton(onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary, width: 1.5), minimumSize: size, shape: shape, padding: const EdgeInsets.symmetric(horizontal: 20)),
            child: child));
      case BtnVariant.ghost:
        return TextButton(onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(foregroundColor: AppColors.primary, minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 4)),
          child: child);
      case BtnVariant.danger:
        return SizedBox(height: height, width: fullWidth ? double.infinity : null,
          child: ElevatedButton(onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.white, elevation: 0, minimumSize: size, shape: shape, padding: const EdgeInsets.symmetric(horizontal: 20)),
            child: child));
    }
  }

  Color get _fg {
    switch (variant) {
      case BtnVariant.primary: case BtnVariant.danger: return AppColors.white;
      case BtnVariant.secondary: case BtnVariant.ghost: return AppColors.primary;
    }
  }
}
