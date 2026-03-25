import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/mock/mock_data.dart';
import 'package:bhadabook/domain/payment/models/payment_dto.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class PaymentEvent {}
class PaymentLoad    extends PaymentEvent {}
class PaymentMarkPaid extends PaymentEvent {
  final String   paymentId;
  final String   paymentMode;
  final String?  notes;
  const PaymentMarkPaid({required this.paymentId, required this.paymentMode, this.notes});
}

// ── State ─────────────────────────────────────────────────────────────────────
class PaymentState {
  final bool   loading, saving;
  final bool   success;
  final List<Payment> payments;
  const PaymentState({this.loading = false, this.saving = false, this.success = false, this.payments = const []});
  PaymentState cp({bool? loading, bool? saving, bool? success, List<Payment>? payments}) =>
      PaymentState(loading: loading ?? this.loading, saving: saving ?? this.saving, success: success ?? this.success, payments: payments ?? this.payments);
}

// ── Bloc ──────────────────────────────────────────────────────────────────────
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<PaymentLoad>(_load);
    on<PaymentMarkPaid>(_markPaid);
  }

  Future<void> _load(PaymentLoad _, Emitter<PaymentState> emit) async {
    emit(state.cp(loading: true));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.cp(loading: false, payments: [...mockPayments]));
  }

  Future<void> _markPaid(PaymentMarkPaid e, Emitter<PaymentState> emit) async {
    emit(state.cp(saving: true));
    await Future.delayed(const Duration(milliseconds: 600));
    final idx = mockPayments.indexWhere((p) => p.id == e.paymentId);
    if (idx >= 0) {
      mockPayments[idx] = mockPayments[idx].copyWith(
        status:      PaymentStatus.paid,
        paymentMode: e.paymentMode,
        paymentDate: DateTime.now(),
        notes:       e.notes,
      );
    }
    emit(state.cp(saving: false, success: true, payments: [...mockPayments]));
  }
}
