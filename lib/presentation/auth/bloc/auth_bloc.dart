import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/auth/models/user_dto.dart';
import 'package:bhadabook/domain/core/config/app_config.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';

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
  final AppStateNotifier _stateNotifier;
  AuthBloc(this._stateNotifier) : super(AuthInitial()) {
    on<AuthCheckRequested>(_check);
    on<AuthSendOtp>(_sendOtp);
    on<AuthVerifyOtp>(_verifyOtp);
    on<AuthSignOut>(_signOut);
  }

  Future<void> _check(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(AuthUnauthenticated());
    navigator<NavigationService>().replaceWith(AppRoutes.welcome);
  }

  Future<void> _sendOtp(AuthSendOtp e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    final state = AuthOtpSent(vid: 'mock-vid-${e.phone}', phone: '+91${e.phone}');
    emit(state);
    navigator<NavigationService>().navigateTo(AppRoutes.otp, arguments: '+91${e.phone}');
  }

  Future<void> _verifyOtp(AuthVerifyOtp e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (e.otp.length == 6) {
      final user = AppUser(id: 'u1', phone: '+919876543210', name: 'Abhinav Singh');
      _stateNotifier.updateUser(user, onboarded: false);
      emit(AuthAuthenticated(user: user, onboarded: false));
      navigator<NavigationService>().pushAndRemoveAll(AppRoutes.onboardStep1);
    } else {
      emit(AuthOtpError('Invalid OTP. Please try again.'));
    }
  }

  Future<void> _signOut(AuthSignOut e, Emitter<AuthState> emit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _stateNotifier.clearUser();
    emit(AuthUnauthenticated());
    navigator<NavigationService>().pushAndRemoveAll(AppRoutes.welcome);
  }
}
