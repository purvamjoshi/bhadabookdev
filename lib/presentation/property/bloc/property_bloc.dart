import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/mock/mock_data.dart';
import 'package:bhadabook/domain/property/models/property_dto.dart';

// ── Events ────────────────────────────────────────────────────────────────
abstract class PropertyEvent {}
class PropertyLoad    extends PropertyEvent {}
class PropertyTabChange extends PropertyEvent { final int tab; PropertyTabChange(this.tab); }
class PropertyDelete  extends PropertyEvent { final String id; PropertyDelete(this.id); }
class PropertyAdd     extends PropertyEvent { final Property property; PropertyAdd(this.property); }
class PropertyUpdate  extends PropertyEvent { final Property property; PropertyUpdate(this.property); }

// ── State ─────────────────────────────────────────────────────────────────
class PropertyState {
  final bool loading;
  final int tab;
  final List<Property> vacant, occupied;
  const PropertyState({this.loading = false, this.tab = 0, this.vacant = const [], this.occupied = const []});
  List<Property> get current => tab == 0 ? vacant : occupied;
  PropertyState cp({bool? loading, int? tab, List<Property>? vacant, List<Property>? occupied}) =>
      PropertyState(loading: loading??this.loading, tab: tab??this.tab, vacant: vacant??this.vacant, occupied: occupied??this.occupied);
}

// ── Bloc ──────────────────────────────────────────────────────────────────
class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(const PropertyState()) {
    on<PropertyLoad>(_load);
    on<PropertyTabChange>((e, emit) => emit(state.cp(tab: e.tab)));
    on<PropertyDelete>(_delete);
    on<PropertyAdd>(_add);
    on<PropertyUpdate>(_update);
  }
  Future<void> _load(PropertyLoad e, Emitter<PropertyState> emit) async {
    emit(state.cp(loading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.cp(loading: false, vacant: mockProperties.where((p) => p.isVacant).toList(), occupied: mockProperties.where((p) => p.isOccupied).toList()));
  }
  void _delete(PropertyDelete e, Emitter<PropertyState> emit) {
    mockProperties.removeWhere((p) => p.id == e.id);
    emit(state.cp(vacant: mockProperties.where((p) => p.isVacant).toList(), occupied: mockProperties.where((p) => p.isOccupied).toList()));
  }
  void _add(PropertyAdd e, Emitter<PropertyState> emit) {
    mockProperties.add(e.property);
    emit(state.cp(vacant: mockProperties.where((p) => p.isVacant).toList(), occupied: mockProperties.where((p) => p.isOccupied).toList()));
  }
  void _update(PropertyUpdate e, Emitter<PropertyState> emit) {
    final idx = mockProperties.indexWhere((p) => p.id == e.property.id);
    if (idx >= 0) mockProperties[idx] = e.property;
    emit(state.cp(vacant: mockProperties.where((p) => p.isVacant).toList(), occupied: mockProperties.where((p) => p.isOccupied).toList()));
  }
}
