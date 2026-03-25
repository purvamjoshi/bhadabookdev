import '../features/property/domain/entities/property.dart';
import '../features/tenant/domain/entities/tenant.dart';
import '../features/agreement/domain/entities/agreement.dart';
import '../features/payment/domain/entities/payment.dart';

// ─── Mock data used throughout the frontend ────────────────────────────────

final mockProperties = [
  Property(id: 'p1', name: 'Greenview Residency', address: 'A-102, Greenview Complex, Near Infocom Circle, S.G. Highway', city: 'Ahmedabad', category: PropertyCategory.residential, subType: PropertySubType.flat, rentUnit: RentUnit.whole, unitName: 'A-102', status: PropertyStatus.occupied, imageUrls: [], createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2025, 3, 1)),
  Property(id: 'p2', name: 'Shreeji Arcade', address: 'Shop No. 5, Shreeji Arcade, CG Road', city: 'Ahmedabad', category: PropertyCategory.commercial, subType: PropertySubType.shop, rentUnit: RentUnit.shopUnit, unitName: 'Shop 5', status: PropertyStatus.occupied, imageUrls: [], createdAt: DateTime(2024, 2, 15), updatedAt: DateTime(2025, 3, 1)),
  Property(id: 'p3', name: 'Skyline Office Space', address: 'Suite B01, Skyline Tower, Prahlad Nagar', city: 'Ahmedabad', category: PropertyCategory.commercial, subType: PropertySubType.officeSpace, rentUnit: RentUnit.whole, unitName: 'Suite B01', status: PropertyStatus.occupied, imageUrls: [], createdAt: DateTime(2024, 3, 5), updatedAt: DateTime(2025, 3, 1)),
  Property(id: 'p4', name: 'Shanti Nagar Floors', address: '14, Shanti Nagar Society, Paldi', city: 'Ahmedabad', category: PropertyCategory.residential, subType: PropertySubType.rowHouse, rentUnit: RentUnit.floor, unitName: '1st Floor', status: PropertyStatus.occupied, imageUrls: [], createdAt: DateTime(2024, 4, 20), updatedAt: DateTime(2025, 3, 1)),
  Property(id: 'p5', name: 'Sai Industrial Warehouse', address: 'Plot 8, GIDC Phase 2, Vatva', city: 'Ahmedabad', category: PropertyCategory.commercial, subType: PropertySubType.warehouse, rentUnit: RentUnit.whole, unitName: 'Bay 4', status: PropertyStatus.occupied, imageUrls: [], createdAt: DateTime(2024, 5, 1), updatedAt: DateTime(2025, 3, 1)),
  Property(id: 'p6', name: 'Sunrise Villa', address: 'B-12, Sunrise Enclave, Bopal', city: 'Ahmedabad', category: PropertyCategory.residential, subType: PropertySubType.villa, rentUnit: RentUnit.whole, unitName: 'Villa B12', status: PropertyStatus.vacant, imageUrls: [], createdAt: DateTime(2024, 6, 10), updatedAt: DateTime(2025, 3, 1)),
];

final mockTenants = [
  Tenant(id: 't1', name: 'Aarav Mehta', phone: '+919876543210', permanentAddress: '22 Rana Enclave, Adalsen, Surat, Gujarat 395009', identityProofUrls: [], currentPropertyId: 'p1', currentAgreementId: 'a1', createdAt: DateTime(2024, 6, 1), updatedAt: DateTime(2025, 3, 1)),
  Tenant(id: 't2', name: 'Rajesh Patel', phone: '+919765432109', permanentAddress: '7, Patel Nagar, Anand, Gujarat 388001', identityProofUrls: [], currentPropertyId: 'p2', currentAgreementId: 'a2', createdAt: DateTime(2024, 7, 1), updatedAt: DateTime(2025, 3, 1)),
  Tenant(id: 't3', name: 'Priya Shah', phone: '+918854321098', permanentAddress: '45, Shivam Bunglows, Gandhinagar, Gujarat 382028', identityProofUrls: [], currentPropertyId: 'p3', currentAgreementId: 'a3', createdAt: DateTime(2024, 8, 1), updatedAt: DateTime(2025, 3, 1)),
  Tenant(id: 't4', name: 'Mehul Shah', phone: '+918893214567', permanentAddress: 'B-5, Navjivan Society, Rajkot, Gujarat 360001', identityProofUrls: [], currentPropertyId: 'p4', currentAgreementId: 'a4', createdAt: DateTime(2024, 9, 1), updatedAt: DateTime(2025, 3, 1)),
  Tenant(id: 't5', name: 'Kunal Desai', phone: '+918895001456', permanentAddress: 'Suite 201, Dharnidhar Complex, Vadodara, Gujarat 390001', identityProofUrls: [], currentPropertyId: 'p5', currentAgreementId: 'a5', createdAt: DateTime(2024, 10, 1), updatedAt: DateTime(2025, 3, 1)),
];

final mockAgreements = [
  Agreement(id: 'a1', propertyId: 'p1', tenantId: 't1', status: AgreementStatus.active, monthlyRentPaise: 1800000, securityDepositPaise: 3600000, rentDueDay: 5, startDate: DateTime(2024, 7, 1), moveInDate: DateTime(2024, 7, 5), endDate: DateTime(2026, 6, 30), createdAt: DateTime(2024, 7, 1), updatedAt: DateTime(2025, 3, 1)),
  Agreement(id: 'a2', propertyId: 'p2', tenantId: 't2', status: AgreementStatus.active, monthlyRentPaise: 3200000, securityDepositPaise: 6400000, rentDueDay: 1, startDate: DateTime(2024, 8, 1), moveInDate: DateTime(2024, 8, 1), endDate: DateTime(2026, 7, 31), createdAt: DateTime(2024, 8, 1), updatedAt: DateTime(2025, 3, 1)),
  Agreement(id: 'a3', propertyId: 'p3', tenantId: 't3', status: AgreementStatus.active, monthlyRentPaise: 4500000, securityDepositPaise: 9000000, rentDueDay: 10, startDate: DateTime(2024, 9, 1), moveInDate: DateTime(2024, 9, 1), endDate: DateTime(2026, 8, 31), createdAt: DateTime(2024, 9, 1), updatedAt: DateTime(2025, 3, 1)),
  Agreement(id: 'a4', propertyId: 'p4', tenantId: 't4', status: AgreementStatus.active, monthlyRentPaise: 2000000, securityDepositPaise: 4000000, rentDueDay: 5, startDate: DateTime(2024, 10, 1), moveInDate: DateTime(2024, 10, 5), endDate: DateTime(2026, 9, 30), createdAt: DateTime(2024, 10, 1), updatedAt: DateTime(2025, 3, 1)),
  Agreement(id: 'a5', propertyId: 'p5', tenantId: 't5', status: AgreementStatus.active, monthlyRentPaise: 5500000, securityDepositPaise: 11000000, rentDueDay: 1, startDate: DateTime(2024, 11, 1), moveInDate: DateTime(2024, 11, 1), endDate: DateTime(2026, 10, 31), createdAt: DateTime(2024, 11, 1), updatedAt: DateTime(2025, 3, 1)),
  // Expired agreement for tenant t1
  Agreement(id: 'a0', propertyId: 'p1', tenantId: 't1', status: AgreementStatus.expired, monthlyRentPaise: 1600000, securityDepositPaise: 3200000, rentDueDay: 5, startDate: DateTime(2022, 7, 1), moveInDate: DateTime(2022, 7, 5), endDate: DateTime(2024, 6, 30), createdAt: DateTime(2022, 7, 1), updatedAt: DateTime(2024, 7, 1)),
];

final mockPayments = [
  Payment(id: 'pay1', propertyId: 'p5', tenantId: 't5', agreementId: 'a5', amountPaise: 5500000, status: PaymentStatus.overdue, paymentMode: 'cash', monthYear: '2026-03', receiptId: 'BB-2026-03-00001', propertyName: 'Sai Industrial Warehouse', tenantName: 'Kunal Desai', unitName: 'Bay 4', createdAt: DateTime(2026, 3, 1), updatedAt: DateTime(2026, 3, 1)),
  Payment(id: 'pay2', propertyId: 'p1', tenantId: 't1', agreementId: 'a1', amountPaise: 1800000, status: PaymentStatus.pending, paymentMode: 'upi', monthYear: '2026-03', receiptId: 'BB-2026-03-00002', propertyName: 'Greenview Residency', tenantName: 'Aarav Mehta', unitName: 'A-102', createdAt: DateTime(2026, 3, 1), updatedAt: DateTime(2026, 3, 1)),
  Payment(id: 'pay3', propertyId: 'p2', tenantId: 't2', agreementId: 'a2', amountPaise: 3200000, status: PaymentStatus.pending, paymentMode: 'bank_transfer', monthYear: '2026-03', receiptId: 'BB-2026-03-00003', propertyName: 'Shreeji Arcade', tenantName: 'Rajesh Patel', unitName: 'Shop 5', createdAt: DateTime(2026, 3, 1), updatedAt: DateTime(2026, 3, 1)),
  Payment(id: 'pay4', propertyId: 'p3', tenantId: 't3', agreementId: 'a3', amountPaise: 4500000, status: PaymentStatus.paid, paymentMode: 'upi', paymentDate: DateTime(2026, 3, 2), monthYear: '2026-03', receiptId: 'BB-2026-03-00004', propertyName: 'Skyline Office Space', tenantName: 'Priya Shah', unitName: 'Suite B01', createdAt: DateTime(2026, 3, 1), updatedAt: DateTime(2026, 3, 2)),
  Payment(id: 'pay5', propertyId: 'p4', tenantId: 't4', agreementId: 'a4', amountPaise: 2000000, status: PaymentStatus.paid, paymentMode: 'cash', paymentDate: DateTime(2026, 3, 5), monthYear: '2026-03', receiptId: 'BB-2026-03-00005', propertyName: 'Shanti Nagar Floors', tenantName: 'Mehul Shah', unitName: '1st Floor', createdAt: DateTime(2026, 3, 1), updatedAt: DateTime(2026, 3, 5)),
];

final mockNotifications = [
  AppNotification(id: 'n1', title: 'Rent Due Reminder', body: 'Rent for Greenview Residency (A-102) is due in 2 days.', createdAt: DateTime(2026, 3, 23), read: false),
  AppNotification(id: 'n2', title: 'Payment Received', body: 'Priya Shah has paid ₹45,000 for Skyline Office Space.', createdAt: DateTime(2026, 3, 22), read: false),
  AppNotification(id: 'n3', title: 'Agreement Expiring Soon', body: 'Agreement for Sai Industrial Warehouse expires in 30 days.', createdAt: DateTime(2026, 3, 20), read: true),
  AppNotification(id: 'n4', title: 'Overdue Payment Alert', body: 'Kunal Desai\'s rent for Bay 4 is overdue by 5 days.', createdAt: DateTime(2026, 3, 18), read: true),
];

class AppNotification {
  final String id, title, body;
  final DateTime createdAt;
  final bool read;
  const AppNotification({required this.id, required this.title, required this.body, required this.createdAt, this.read = false});
}
