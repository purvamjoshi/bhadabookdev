import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';

// ── Events ────────────────────────────────────────────────────────────────
abstract class AuthEvent {}
class AuthCheckRequested  extends AuthEvent {}
class AuthSendOtp         extends AuthEvent { final String phone; AuthSendOtp(this.phone); }
class AuthVerifyOtp       extends AuthEvent { final String vid, otp; AuthVerifyOtp(this.vid, this.otp); }
class AuthSignOut         extends AuthEvent {}

// ── States ────────────────────────────────────────────────────────────────
abstract class AuthState {}
class AuthInitial        extends AuthState {}
class AuthLoading        extends AuthState {}
class AuthOtpSent        extends AuthState { final String vid, phone; AuthOtpSent({required this.vid, required this.phone}); }
class AuthAuthenticated  extends AuthState { final AppUser user; final bool onboarded; AuthAuthenticated({required this.user, required this.onboarded}); }
class AuthUnauthenticated extends AuthState {}
class AuthOtpError       extends AuthState { final String msg; AuthOtpError(this.msg); }
class AuthError          extends AuthState { final String msg; AuthError(this.msg); }

// ── Bloc ──────────────────────────────────────────────────────────────────
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_check);
    on<AuthSendOtp>(_sendOtp);
    on<AuthVerifyOtp>(_verifyOtp);
    on<AuthSignOut>(_signOut);
  }

  Future<void> _check(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: not authenticated on first launch
    emit(AuthUnauthenticated());
  }

  Future<void> _sendOtp(AuthSendOtp e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthOtpSent(vid: 'mock-verification-id-${e.phone}', phone: '+91${e.phone}'));
  }

  Future<void> _verifyOtp(AuthVerifyOtp e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (e.otp == '123456' || e.otp.length == 6) {
      // Mock: treat as new user if OTP is first 6 digits
      final user = AppUser(id: 'u1', phone: '+919876543210', name: 'Abhinav Singh', email: null, preferredLanguage: 'en');
      emit(AuthAuthenticated(user: user, onboarded: false));
    } else {
      emit(AuthOtpError('Invalid OTP. Please try again.'));
    }
  }

  Future<void> _signOut(AuthSignOut e, Emitter<AuthState> emit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    emit(AuthUnauthenticated());
  }
}
