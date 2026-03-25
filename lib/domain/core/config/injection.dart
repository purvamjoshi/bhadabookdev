import 'package:get_it/get_it.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';

final GetIt getIt = GetIt.instance;

/// Alias matching the template pattern: navigator<T>()
T navigator<T extends Object>() => getIt<T>();

void setupLocator() {
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
}
