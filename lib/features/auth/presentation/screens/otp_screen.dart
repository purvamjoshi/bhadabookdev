import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/bb_button.dart';
import '../bloc/auth_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String phone, vid;
  const OtpScreen({super.key, required this.phone, required this.vid});
  @override State<OtpScreen> createState() => _State();
}

class _State extends State<OtpScreen> {
  static const _len = 6;
  late final List<TextEditingController> _cs = List.generate(_len, (_) => TextEditingController());
  late final List<FocusNode>             _fs = List.generate(_len, (_) => FocusNode());
  late Timer _timer;
  int _secs = 60;
  bool _canResend = false;
  String? _err;

  String get _otp => _cs.map((c) => c.text).join();
  bool get _full => _otp.length == _len;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fs[0].requestFocus());
  }

  void _startTimer() {
    _secs = 60; _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() { if (_secs > 0) { _secs--; } else { _canResend = true; t.cancel(); } });
    });
  }

  @override void dispose() { _timer.cancel(); for (final c in _cs) c.dispose(); for (final f in _fs) f.dispose(); super.dispose(); }

  void _onChange(int i, String v) {
    setState(() => _err = null);
    if (v.isNotEmpty && i < _len - 1) _fs[i + 1].requestFocus();
    if (_full) _verify();
  }

  void _onKey(int i, KeyEvent e) {
    if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.backspace && _cs[i].text.isEmpty && i > 0) _fs[i - 1].requestFocus();
  }

  void _verify() {
    if (!_full) return;
    context.read<AuthBloc>().add(AuthVerifyOtp(widget.vid, _otp));
  }

  void _resend() {
    if (!_canResend) return;
    for (final c in _cs) c.clear();
    _fs[0].requestFocus();
    _startTimer();
    final phone = widget.phone.replaceAll(RegExp(r'[^\d]'), '').substring(2);
    context.read<AuthBloc>().add(AuthSendOtp(phone));
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    listener: (ctx, s) {
      if (s is AuthAuthenticated) ctx.go(s.onboarded ? '/home' : '/onboarding/step1');
      if (s is AuthOtpSent)   { setState(() { _startTimer(); }); }
      if (s is AuthOtpError)  { setState(() { _err = s.msg; for (final c in _cs) c.clear(); }); _fs[0].requestFocus(); }
    },
    child: Scaffold(backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop())),
      body: SafeArea(child: Padding(padding: S.pageAll, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        Text('Enter The\nVerification Code', style: T.h1),
        const SizedBox(height: 8),
        RichText(text: TextSpan(style: T.bodySm, children: [
          const TextSpan(text: 'We have sent a 6 digit verification code to\n'),
          TextSpan(text: Fmt.maskPhone(widget.phone), style: T.bodySmMd.copyWith(color: AppColors.navy, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(height: 32),
        // OTP boxes
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(_len, (i) => _OtpBox(ctrl: _cs[i], node: _fs[i], hasErr: _err != null, onChanged: (v) => _onChange(i, v), onKey: (e) => _onKey(i, e)))),
        const SizedBox(height: 10),
        if (_err != null) Text(_err!, style: T.bodySm.copyWith(color: AppColors.error)),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: _canResend ? _resend : null,
          child: _canResend
            ? Text('Resend OTP', style: T.bodySmMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))
            : Text('Resend OTP in ${_secs}s', style: T.bodySm),
        ),
        const Spacer(),
        BlocBuilder<AuthBloc, AuthState>(builder: (_, s) => BBButton(label: 'VERIFY', isLoading: s is AuthLoading, onPressed: _full && s is! AuthLoading ? _verify : null)),
        const SizedBox(height: 16),
      ]))),
    ),
  );
}

class _OtpBox extends StatelessWidget {
  final TextEditingController ctrl; final FocusNode node; final bool hasErr;
  final ValueChanged<String> onChanged; final ValueChanged<KeyEvent> onKey;
  const _OtpBox({required this.ctrl, required this.node, required this.hasErr, required this.onChanged, required this.onKey});

  @override
  Widget build(BuildContext context) => SizedBox(width: 48, height: 54,
    child: KeyboardListener(focusNode: FocusNode(), onKeyEvent: onKey,
      child: TextField(controller: ctrl, focusNode: node, keyboardType: TextInputType.number, textAlign: TextAlign.center, maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
        decoration: InputDecoration(counterText: '', filled: true,
          fillColor: hasErr ? AppColors.errorLight : AppColors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasErr ? AppColors.borderError : AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasErr ? AppColors.borderError : AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasErr ? AppColors.borderError : AppColors.borderActive, width: 2)),
        ),
      ),
    ),
  );
}
