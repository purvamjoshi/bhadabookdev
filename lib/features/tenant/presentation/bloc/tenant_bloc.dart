import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../mock/mock_data.dart';
import '../../domain/entities/tenant.dart';

// ── Events ────────────────────────────────────────────────────────────────
abstract class TenantEvent {}
class TenantLoad   extends TenantEvent {}
class TenantAdd    extends TenantEvent { final Tenant tenant; TenantAdd(this.tenant); }
class TenantUpdate extends TenantEvent { final Tenant tenant; TenantUpdate(this.tenant); }
class TenantDelete extends TenantEvent { final String id; TenantDelete(this.id); }

// ── State ─────────────────────────────────────────────────────────────────
class TenantState {
  final bool loading;
  final List<Tenant> tenants;
  const TenantState({this.loading = false, this.tenants = const []});
  TenantState cp({bool? loading, List<Tenant>? tenants}) =>
      TenantState(loading: loading ?? this.loading, tenants: tenants ?? this.tenants);
}

// ── Bloc ──────────────────────────────────────────────────────────────────
class TenantBloc extends Bloc<TenantEvent, TenantState> {
  TenantBloc() : super(const TenantState()) {
    on<TenantLoad>(_load);
    on<TenantAdd>(_add);
    on<TenantUpdate>(_update);
    on<TenantDelete>(_delete);
  }

  Future<void> _load(TenantLoad e, Emitter<TenantState> emit) async {
    emit(state.cp(loading: true));
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = [...mockTenants]..sort((a, b) => a.name.compareTo(b.name));
    emit(state.cp(loading: false, tenants: sorted));
  }

  void _add(TenantAdd e, Emitter<TenantState> emit) {
    mockTenants.add(e.tenant);
    final sorted = [...mockTenants]..sort((a, b) => a.name.compareTo(b.name));
    emit(state.cp(tenants: sorted));
  }

  void _update(TenantUpdate e, Emitter<TenantState> emit) {
    final idx = mockTenants.indexWhere((t) => t.id == e.tenant.id);
    if (idx >= 0) mockTenants[idx] = e.tenant;
    final sorted = [...mockTenants]..sort((a, b) => a.name.compareTo(b.name));
    emit(state.cp(tenants: sorted));
  }

  void _delete(TenantDelete e, Emitter<TenantState> emit) {
    mockTenants.removeWhere((t) => t.id == e.id);
    final sorted = [...mockTenants]..sort((a, b) => a.name.compareTo(b.name));
    emit(state.cp(tenants: sorted));
  }
}
