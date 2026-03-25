enum PropertyCategory { residential, commercial }

enum PropertySubType {
  flat, bungalow, rowHouse, penthouse, villa, chawlRoom, pgRoom,
  shop, officeSpace, warehouse, showroom, godown, factoryUnit;

  String get label => const {
    PropertySubType.flat:         'Flat / Apartment',
    PropertySubType.bungalow:     'Bungalow',
    PropertySubType.rowHouse:     'Row House',
    PropertySubType.penthouse:    'Penthouse',
    PropertySubType.villa:        'Villa',
    PropertySubType.chawlRoom:    'Chawl Room',
    PropertySubType.pgRoom:       'PG Room',
    PropertySubType.shop:         'Shop',
    PropertySubType.officeSpace:  'Office Space',
    PropertySubType.warehouse:    'Warehouse',
    PropertySubType.showroom:     'Showroom',
    PropertySubType.godown:       'Godown',
    PropertySubType.factoryUnit:  'Factory Unit',
  }[this]!;
}

enum RentUnit {
  whole, floor, room, shopUnit, bed, seat;

  String get label => const {
    RentUnit.whole:    'Whole Property',
    RentUnit.floor:    'By Floor',
    RentUnit.room:     'By Room',
    RentUnit.shopUnit: 'By Shop Unit',
    RentUnit.bed:      'By Bed',
    RentUnit.seat:     'By Seat',
  }[this]!;
}

enum PropertyStatus { vacant, occupied }

class Property {
  final String id, name, address, city;
  final PropertyCategory category;
  final PropertySubType subType;
  final RentUnit rentUnit;
  final String? unitName;
  final PropertyStatus status;
  final List<String> imageUrls;
  final DateTime createdAt, updatedAt;

  const Property({
    required this.id, required this.name, required this.address, required this.city,
    required this.category, required this.subType, required this.rentUnit,
    this.unitName, this.status = PropertyStatus.vacant,
    this.imageUrls = const [],
    required this.createdAt, required this.updatedAt,
  });

  bool get isVacant   => status == PropertyStatus.vacant;
  bool get isOccupied => status == PropertyStatus.occupied;

  String get categoryLabel => category == PropertyCategory.residential ? 'Residential' : 'Commercial';
  String get subTypeLabel  => subType.label;
  String get rentUnitLabel => rentUnit.label;

  Property copyWith({
    String? name, String? address, String? city, String? unitName,
    PropertyCategory? category, PropertySubType? subType, RentUnit? rentUnit,
    PropertyStatus? status, List<String>? imageUrls,
  }) => Property(
    id: id,
    name:      name      ?? this.name,
    address:   address   ?? this.address,
    city:      city      ?? this.city,
    category:  category  ?? this.category,
    subType:   subType   ?? this.subType,
    rentUnit:  rentUnit  ?? this.rentUnit,
    unitName:  unitName  ?? this.unitName,
    status:    status    ?? this.status,
    imageUrls: imageUrls ?? this.imageUrls,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );
}
