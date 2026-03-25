import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/auth/bloc/auth_bloc.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});
  @override State<PhoneInputScreen> createState() => _State();
}

class _State extends State<PhoneInputScreen> {
  final _ctrl = TextEditingController();
  String? _err;
  bool get _ready => _ctrl.text.length == 10;

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _submit() {
    final v = _ctrl.text.trim();
    if (v.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
      setState(() => _err = 'Enter a valid 10-digit Indian mobile number'); return;
    }
    setState(() => _err = null);
    context.read<AuthBloc>().add(AuthSendOtp(v));
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    listener: (ctx, s) {
      if (s is AuthError) setState(() => _err = s.msg);
    },
    child: Scaffold(backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().pushAndRemoveAll(AppRoutes.welcome))),
      body: SafeArea(child: Padding(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        Text('Enter Your\nPhone Number', style: T.h1),
        const SizedBox(height: 8),
        Text("Use your phone number to continue. We'll send a verification code to confirm it's you.", style: T.bodySm.copyWith(height: 1.6)),
        const SizedBox(height: 32),
        Text('Mobile Number *', style: T.label),
        const SizedBox(height: 6),
        _PhoneField(ctrl: _ctrl, err: _err, onChange: (_) => setState(() { _err = null; })),
        const Spacer(),
        BlocBuilder<AuthBloc, AuthState>(builder: (_, s) => BBButton(label: 'CONTINUE', isLoading: s is AuthLoading, onPressed: _ready && s is! AuthLoading ? _submit : null)),
        const SizedBox(height: 16),
      ]))),
    ),
  );
}

class _PhoneField extends StatelessWidget {
  final TextEditingController ctrl; final String? err; final ValueChanged<String> onChange;
  const _PhoneField({required this.ctrl, this.err, required this.onChange});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    TextField(controller: ctrl, keyboardType: TextInputType.phone, maxLength: 10, autofocus: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], onChanged: onChange,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.navy),
      decoration: InputDecoration(
        counterText: '',
        hintText: 'XXXXX XXXXX',
        prefixIcon: Container(padding: const EdgeInsets.symmetric(horizontal: 14), child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('🇮🇳', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
          const Text('+91', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.navy)),
          const SizedBox(width: 8),
          Container(width: 1, height: 22, color: AppColors.grey300),
        ])),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true, fillColor: AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: err != null ? AppColors.borderError : AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderActive, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      )),
    if (err != null) ...[const SizedBox(height: 6), Text(err!, style: T.caption.copyWith(color: AppColors.error))],
  ]);
}
