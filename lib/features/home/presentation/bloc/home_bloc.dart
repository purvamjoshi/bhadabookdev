import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../mock/mock_data.dart';
import '../../../payment/domain/entities/payment.dart';

// ── Events ────────────────────────────────────────────────────────────────
abstract class HomeEvent {}
class HomeLoad       extends HomeEvent { final DateTime month; HomeLoad([DateTime? m]) : month = m ?? DateTime.now(); }
class HomeMonthChange extends HomeEvent { final DateTime month; HomeMonthChange(this.month); }
class HomeTabChange  extends HomeEvent { final int tab; HomeTabChange(this.tab); }
class HomeMarkPaid   extends HomeEvent { final String paymentId; HomeMarkPaid(this.paymentId); }

// ── State ─────────────────────────────────────────────────────────────────
class HomeState {
  final bool loading;
  final int tab;
  final DateTime month;
  final int totalPaise, receivedPaise, pendingPaise;
  final List<Payment> all, overdue, pending, received;
  final bool isNewUser;

  const HomeState({this.loading = false, this.tab = 0, required this.month, this.totalPaise = 0, this.receivedPaise = 0, this.pendingPaise = 0, this.all = const [], this.overdue = const [], this.pending = const [], this.received = const [], this.isNewUser = true});

  List<Payment> get current => switch (tab) { 1 => overdue, 2 => pending, 3 => received, _ => all };

  HomeState cp({bool? loading, int? tab, DateTime? month, int? totalPaise, int? receivedPaise, int? pendingPaise, List<Payment>? all, List<Payment>? overdue, List<Payment>? pending, List<Payment>? received, bool? isNewUser}) =>
      HomeState(loading: loading??this.loading, tab: tab??this.tab, month: month??this.month, totalPaise: totalPaise??this.totalPaise, receivedPaise: receivedPaise??this.receivedPaise, pendingPaise: pendingPaise??this.pendingPaise, all: all??this.all, overdue: overdue??this.overdue, pending: pending??this.pending, received: received??this.received, isNewUser: isNewUser??this.isNewUser);
}

// ── Bloc ──────────────────────────────────────────────────────────────────
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(month: DateTime.now())) {
    on<HomeLoad>(_load);
    on<HomeMonthChange>((e, emit) => emit(state.cp(month: e.month)));
    on<HomeTabChange>((e, emit) => emit(state.cp(tab: e.tab)));
    on<HomeMarkPaid>(_markPaid);
  }

  Future<void> _load(HomeLoad e, Emitter<HomeState> emit) async {
    emit(state.cp(loading: true));
    await Future.delayed(const Duration(milliseconds: 600));
    final payments = mockPayments;
    final all      = payments;
    final overdue  = payments.where((p) => p.isOverdue).toList();
    final pending  = payments.where((p) => p.isPending).toList();
    final received = payments.where((p) => p.isPaid).toList();
    final total    = payments.fold<int>(0, (s, p) => s + p.amountPaise);
    final recv     = received.fold<int>(0, (s, p) => s + p.amountPaise);
    final pend     = (overdue + pending).fold<int>(0, (s, p) => s + p.amountPaise);
    emit(state.cp(loading: false, all: all, overdue: overdue, pending: pending, received: received, totalPaise: total, receivedPaise: recv, pendingPaise: pend, isNewUser: false, month: e.month));
  }

  Future<void> _markPaid(HomeMarkPaid e, Emitter<HomeState> emit) async {
    // Mark payment as paid in mock data (in real app: call repo)
    final idx = mockPayments.indexWhere((p) => p.id == e.paymentId);
    if (idx >= 0) add(HomeLoad(state.month));
  }
}
