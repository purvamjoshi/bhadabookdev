import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../features/agreement/presentation/bloc/agreement_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/payment/presentation/bloc/payment_bloc.dart';
import '../features/property/presentation/bloc/property_bloc.dart';
import '../features/tenant/presentation/bloc/tenant_bloc.dart';
import 'routes/app_router.dart';

class BhadaBookApp extends StatefulWidget {
  const BhadaBookApp({super.key});
  @override State<BhadaBookApp> createState() => _BhadaBookAppState();
}

class _BhadaBookAppState extends State<BhadaBookApp> {
  late final AuthBloc _authBloc;
  late final _AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authBloc     = AuthBloc();
    _authNotifier = _AuthNotifier(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _authNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(      create: (_) => _authBloc),
      BlocProvider<HomeBloc>(      create: (_) => HomeBloc()),
      BlocProvider<PropertyBloc>(  create: (_) => PropertyBloc()),
      BlocProvider<TenantBloc>(    create: (_) => TenantBloc()),
      BlocProvider<AgreementBloc>( create: (_) => AgreementBloc()),
      BlocProvider<PaymentBloc>(   create: (_) => PaymentBloc()),
    ],
    child: MaterialApp.router(
      title:                        'BhadaBook',
      debugShowCheckedModeBanner:   false,
      theme:                        AppTheme.light,
      routerConfig:                 buildRouter(_authBloc),
    ),
  );
}

/// Bridges BLoC state changes to GoRouter's refreshListenable
class _AuthNotifier extends ChangeNotifier {
  final AuthBloc _bloc;
  _AuthNotifier(this._bloc) { _bloc.stream.listen((_) => notifyListeners()); }
}
