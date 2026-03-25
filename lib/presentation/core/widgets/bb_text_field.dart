import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';

class BBTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? error;
  final bool obscure;
  final TextInputType keyboard;
  final TextInputAction action;
  final int maxLines;
  final int? maxLen;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onChange;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final String? prefixText;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const BBTextField({
    super.key, required this.label, this.hint, this.controller, this.error,
    this.obscure = false, this.keyboard = TextInputType.text, this.action = TextInputAction.next,
    this.maxLines = 1, this.maxLen, this.formatters, this.onChange, this.onTap,
    this.readOnly = false, this.prefix, this.suffix, this.prefixText,
    this.autofocus = false, this.focusNode, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: T.label),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller, obscureText: obscure, keyboardType: keyboard,
        textInputAction: action, maxLines: maxLines, maxLength: maxLen,
        inputFormatters: formatters, onChanged: onChange, onTap: onTap,
        readOnly: readOnly, autofocus: autofocus, focusNode: focusNode, validator: validator,
        style: T.body.copyWith(color: AppColors.navy),
        decoration: InputDecoration(
          hintText: hint, counterText: '', filled: true,
          fillColor: readOnly ? AppColors.grey50 : AppColors.white,
          errorText: error,
          prefix: prefixText != null ? _PhonePrefix(prefixText!) : null,
          prefixIcon: prefix, suffixIcon: suffix,
          border: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: BorderSide(color: error != null ? AppColors.borderError : AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: BorderSide(color: error != null ? AppColors.borderError : AppColors.borderActive, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.borderError, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: S.inputR, borderSide: const BorderSide(color: AppColors.borderError, width: 1.5)),
        ),
      ),
    ]);
  }
}

class _PhonePrefix extends StatelessWidget {
  final String text;
  const _PhonePrefix(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('🇮🇳', style: TextStyle(fontSize: 18)),
      const SizedBox(width: 4),
      Text(text, style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(width: 6),
      Container(width: 1, height: 20, color: AppColors.grey300),
    ]),
  );
}
