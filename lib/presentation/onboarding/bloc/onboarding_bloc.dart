import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/property/models/property_dto.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';

// ── Events ────────────────────────────────────────────────────────────────
abstract class OnboardingEvent {}
class OnboardStep1Done extends OnboardingEvent { final String name; final String? email; final String lang; OnboardStep1Done({required this.name, this.email, required this.lang}); }
class OnboardStep2Done extends OnboardingEvent { final PropertyCategory cat; final PropertySubType sub; final RentUnit unit; OnboardStep2Done({required this.cat, required this.sub, required this.unit}); }
class OnboardStep3Done extends OnboardingEvent { final String propName, address, city; OnboardStep3Done({required this.propName, required this.address, required this.city}); }

// ── States ────────────────────────────────────────────────────────────────
abstract class OnboardingState {}
class OnboardInitial extends OnboardingState {}
class OnboardLoading  extends OnboardingState {}
class OnboardStep1    extends OnboardingState {} // navigate to step 2
class OnboardStep2    extends OnboardingState {} // navigate to step 3
class OnboardComplete extends OnboardingState {} // navigate to home
class OnboardError    extends OnboardingState { final String msg; OnboardError(this.msg); }

// ── Bloc ──────────────────────────────────────────────────────────────────
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardInitial()) {
    on<OnboardStep1Done>((e, emit) {
      emit(OnboardStep1());
      navigator<NavigationService>().navigateTo(AppRoutes.onboardStep2);
    });
    on<OnboardStep2Done>((e, emit) {
      emit(OnboardStep2());
      navigator<NavigationService>().navigateTo(AppRoutes.onboardStep3);
    });
    on<OnboardStep3Done>((e, emit) async {
      emit(OnboardLoading());
      await Future.delayed(const Duration(milliseconds: 600));
      emit(OnboardComplete());
      navigator<NavigationService>().pushAndRemoveAll(AppRoutes.home);
    });
  }
}
