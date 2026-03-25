import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../mock/mock_data.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../property/domain/entities/property.dart';
import '../../../tenant/domain/entities/tenant.dart';
import '../../domain/entities/agreement.dart';

// ── Draft model ───────────────────────────────────────────────────────────────
class AgreementDraft {
  final String? agreementId;  // non-null = edit mode
  final String? propertyId;
  final String? tenantId;
  final bool    isNewTenant;
  // Step 1 — tenant
  final String? tenantName, tenantPhone, tenantAddress;
  // Step 2 — rent
  final int?    monthlyRentPaise, securityDepositPaise, rentDueDay;
  final String? paymentMode;
  // Step 3 — dates
  final DateTime? startDate, moveInDate, endDate;

  const AgreementDraft({
    this.agreementId, this.propertyId, this.tenantId, this.isNewTenant = true,
    this.tenantName, this.tenantPhone, this.tenantAddress,
    this.monthlyRentPaise, this.securityDepositPaise, this.rentDueDay, this.paymentMode,
    this.startDate, this.moveInDate, this.endDate,
  });

  AgreementDraft cp({
    String? agreementId, String? propertyId, String? tenantId, bool? isNewTenant,
    String? tenantName, String? tenantPhone, String? tenantAddress,
    int? monthlyRentPaise, int? securityDepositPaise, int? rentDueDay, String? paymentMode,
    DateTime? startDate, DateTime? moveInDate, DateTime? endDate,
  }) => AgreementDraft(
    agreementId:          agreementId          ?? this.agreementId,
    propertyId:           propertyId           ?? this.propertyId,
    tenantId:             tenantId             ?? this.tenantId,
    isNewTenant:          isNewTenant          ?? this.isNewTenant,
    tenantName:           tenantName           ?? this.tenantName,
    tenantPhone:          tenantPhone          ?? this.tenantPhone,
    tenantAddress:        tenantAddress        ?? this.tenantAddress,
    monthlyRentPaise:     monthlyRentPaise     ?? this.monthlyRentPaise,
    securityDepositPaise: securityDepositPaise ?? this.securityDepositPaise,
    rentDueDay:           rentDueDay           ?? this.rentDueDay,
    paymentMode:          paymentMode          ?? this.paymentMode,
    startDate:            startDate            ?? this.startDate,
    moveInDate:           moveInDate           ?? this.moveInDate,
    endDate:              endDate              ?? this.endDate,
  );
}

// ── Events ────────────────────────────────────────────────────────────────────
abstract class AgreementEvent {}
class AgreementInit       extends AgreementEvent { final Map<String, dynamic> extra; AgreementInit(this.extra); }
class AgreementStep1Done  extends AgreementEvent { final String name, phone, address; AgreementStep1Done({required this.name, required this.phone, required this.address}); }
class AgreementStep2Done  extends AgreementEvent { final int rentPaise, depositPaise, dueDay; final String mode; AgreementStep2Done({required this.rentPaise, required this.depositPaise, required this.dueDay, required this.mode}); }
class AgreementStep3Done  extends AgreementEvent { final DateTime start, moveIn, end; AgreementStep3Done({required this.start, required this.moveIn, required this.end}); }
class AgreementReset      extends AgreementEvent {}

// ── State ─────────────────────────────────────────────────────────────────────
enum AgreementStatus2 { idle, loading, success, error }
class AgreementState {
  final AgreementStatus2 status;
  final AgreementDraft draft;
  final String? error;
  const AgreementState({this.status = AgreementStatus2.idle, this.draft = const AgreementDraft(), this.error});
  AgreementState cp({AgreementStatus2? status, AgreementDraft? draft, String? error}) =>
      AgreementState(status: status ?? this.status, draft: draft ?? this.draft, error: error ?? this.error);
}

// ── Bloc ──────────────────────────────────────────────────────────────────────
class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  AgreementBloc() : super(const AgreementState()) {
    on<AgreementInit>(_init);
    on<AgreementStep1Done>(_step1);
    on<AgreementStep2Done>(_step2);
    on<AgreementStep3Done>(_step3);
    on<AgreementReset>((_, emit) => emit(const AgreementState()));
  }

  void _init(AgreementInit e, Emitter<AgreementState> emit) {
    final extra  = e.extra;
    var draft    = const AgreementDraft();
    final aId    = extra['agreementId'] as String?;
    final pId    = extra['propertyId']  as String?;
    final tId    = extra['tenantId']    as String?;
    final isEdit = extra['edit'] == true;

    if (isEdit && aId != null) {
      final agr = mockAgreements.where((a) => a.id == aId).firstOrNull;
      if (agr != null) {
        final tenant = mockTenants.where((t) => t.id == agr.tenantId).firstOrNull;
        draft = draft.cp(
          agreementId:          aId,
          propertyId:           agr.propertyId,
          tenantId:             agr.tenantId,
          isNewTenant:          false,
          tenantName:           tenant?.name,
          tenantPhone:          tenant?.phone,
          tenantAddress:        tenant?.permanentAddress,
          monthlyRentPaise:     agr.monthlyRentPaise,
          securityDepositPaise: agr.securityDepositPaise,
          rentDueDay:           agr.rentDueDay,
          startDate:            agr.startDate,
          moveInDate:           agr.moveInDate,
          endDate:              agr.endDate,
        );
      }
    } else {
      draft = draft.cp(propertyId: pId, tenantId: tId);
    }
    emit(state.cp(draft: draft));
  }

  void _step1(AgreementStep1Done e, Emitter<AgreementState> emit) {
    emit(state.cp(draft: state.draft.cp(tenantName: e.name, tenantPhone: e.phone, tenantAddress: e.address)));
  }

  void _step2(AgreementStep2Done e, Emitter<AgreementState> emit) {
    emit(state.cp(draft: state.draft.cp(
      monthlyRentPaise: e.rentPaise, securityDepositPaise: e.depositPaise,
      rentDueDay: e.dueDay, paymentMode: e.mode,
    )));
  }

  Future<void> _step3(AgreementStep3Done e, Emitter<AgreementState> emit) async {
    final draft = state.draft.cp(startDate: e.start, moveInDate: e.moveIn, endDate: e.end);
    emit(state.cp(status: AgreementStatus2.loading, draft: draft));
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      if (draft.agreementId != null) {
        // Edit mode
        final idx = mockAgreements.indexWhere((a) => a.id == draft.agreementId);
        if (idx >= 0) {
          final old = mockAgreements[idx];
          mockAgreements[idx] = Agreement(
            id: old.id, propertyId: old.propertyId, tenantId: old.tenantId,
            status: old.status,
            monthlyRentPaise:     draft.monthlyRentPaise     ?? old.monthlyRentPaise,
            securityDepositPaise: draft.securityDepositPaise ?? old.securityDepositPaise,
            rentDueDay:           draft.rentDueDay           ?? old.rentDueDay,
            startDate:            draft.startDate            ?? old.startDate,
            moveInDate:           draft.moveInDate           ?? old.moveInDate,
            endDate:              draft.endDate              ?? old.endDate,
            createdAt: old.createdAt, updatedAt: DateTime.now(),
          );
          // Update tenant info
          if (draft.tenantId != null) {
            final tIdx = mockTenants.indexWhere((t) => t.id == draft.tenantId);
            if (tIdx >= 0 && draft.tenantName != null) {
              mockTenants[tIdx] = mockTenants[tIdx].copyWith(
                name:             draft.tenantName,
                phone:            draft.tenantPhone,
                permanentAddress: draft.tenantAddress,
              );
            }
          }
        }
      } else {
        // Create mode — create tenant if new
        String tenantId = draft.tenantId ?? '';
        if (draft.isNewTenant) {
          final newTenant = Tenant(
            id: 'T${DateTime.now().millisecondsSinceEpoch}',
            name:             draft.tenantName    ?? '',
            phone:            draft.tenantPhone   ?? '',
            permanentAddress: draft.tenantAddress ?? '',
            currentPropertyId: draft.propertyId,
            createdAt: DateTime.now(), updatedAt: DateTime.now(),
          );
          mockTenants.add(newTenant);
          tenantId = newTenant.id;
        }
        final aId = 'A${DateTime.now().millisecondsSinceEpoch}';
        mockAgreements.add(Agreement(
          id: aId, propertyId: draft.propertyId ?? '', tenantId: tenantId,
          status: AgreementStatus.active,
          monthlyRentPaise:     draft.monthlyRentPaise     ?? 0,
          securityDepositPaise: draft.securityDepositPaise ?? 0,
          rentDueDay:           draft.rentDueDay           ?? 1,
          startDate:  draft.startDate  ?? DateTime.now(),
          moveInDate: draft.moveInDate ?? DateTime.now(),
          endDate:    draft.endDate    ?? DateTime.now().add(const Duration(days: 365)),
          createdAt: DateTime.now(), updatedAt: DateTime.now(),
        ));
        // Generate payment for current month
        final now = DateTime.now();
        mockPayments.add(Payment(
          id: 'PAY${DateTime.now().millisecondsSinceEpoch}',
          propertyId: draft.propertyId ?? '', tenantId: tenantId, agreementId: aId,
          amountPaise: draft.monthlyRentPaise ?? 0,
          status: PaymentStatus.pending, paymentMode: draft.paymentMode ?? 'cash',
          monthYear: '${now.year}-${now.month.toString().padLeft(2, '0')}',
          receiptId: 'BB-${now.year}-${now.month.toString().padLeft(2, '0')}-${mockPayments.length + 1}',
          propertyName: mockProperties.where((p) => p.id == draft.propertyId).firstOrNull?.name,
          tenantName: draft.tenantName,
          createdAt: DateTime.now(), updatedAt: DateTime.now(),
        ));
        // Mark property as occupied
        final pIdx = mockProperties.indexWhere((p) => p.id == draft.propertyId);
        if (pIdx >= 0) mockProperties[pIdx] = mockProperties[pIdx].copyWith(status: PropertyStatus.occupied);
        // Link tenant to property + agreement
        final tIdx = mockTenants.indexWhere((t) => t.id == tenantId);
        if (tIdx >= 0) mockTenants[tIdx] = mockTenants[tIdx].copyWith(currentPropertyId: draft.propertyId, currentAgreementId: aId);
      }
      emit(state.cp(status: AgreementStatus2.success, draft: draft));
    } catch (e) {
      emit(state.cp(status: AgreementStatus2.error, error: e.toString()));
    }
  }
}
