import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:bhadabook/domain/core/theme/app_theme.dart';
import 'package:bhadabook/domain/core/config/app_config.dart';
import 'package:bhadabook/domain/core/config/flavor_config.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/routing_config.dart';
import 'package:bhadabook/presentation/auth/bloc/auth_bloc.dart';
import 'package:bhadabook/presentation/home/bloc/home_bloc.dart';
import 'package:bhadabook/presentation/property/bloc/property_bloc.dart';
import 'package:bhadabook/presentation/tenant/bloc/tenant_bloc.dart';
import 'package:bhadabook/presentation/agreement/bloc/agreement_bloc.dart';
import 'package:bhadabook/presentation/payment/bloc/payment_bloc.dart';
import 'package:bhadabook/presentation/onboarding/bloc/onboarding_bloc.dart';

class BhadaBookApp extends StatefulWidget {
  final FlavorConfig flavor;
  const BhadaBookApp({super.key, required this.flavor});
  @override State<BhadaBookApp> createState() => _BhadaBookAppState();
}

class _BhadaBookAppState extends State<BhadaBookApp> {
  late final AppStateNotifier _stateNotifier;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _stateNotifier = AppStateNotifier();
    _authBloc = AuthBloc(_stateNotifier);
  }

  @override
  void dispose() {
    _authBloc.close();
    _stateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AppStateNotifier>.value(
    value: _stateNotifier,
    child: AppConfig(
      flavor: widget.flavor,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<HomeBloc>(      create: (_) => HomeBloc()),
          BlocProvider<PropertyBloc>(  create: (_) => PropertyBloc()),
          BlocProvider<TenantBloc>(    create: (_) => TenantBloc()),
          BlocProvider<AgreementBloc>( create: (_) => AgreementBloc()),
          BlocProvider<PaymentBloc>(   create: (_) => PaymentBloc()),
          BlocProvider<OnboardingBloc>(create: (_) => OnboardingBloc()),
        ],
        child: MaterialApp(
          title:                      'BhadaBook',
          debugShowCheckedModeBanner: widget.flavor.showDebugBanner,
          theme:                      AppTheme.light,
          navigatorKey:               navigator<NavigationService>().navigationKey,
          onGenerateRoute:            generateRoute,
          initialRoute:               '/',
        ),
      ),
    ),
  );
}
