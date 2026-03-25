import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/bb_button.dart';
import '../../../../core/widgets/bb_card.dart';
import '../../../../core/widgets/bb_radio_card.dart';
import '../../../../core/widgets/bb_text_field.dart';
import '../../domain/entities/property.dart';
import '../bloc/property_bloc.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});
  @override State<AddPropertyScreen> createState() => _State();
}

class _State extends State<AddPropertyScreen> {
  final _nameCtrl    = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl    = TextEditingController();
  final _unitCtrl    = TextEditingController();

  PropertyCategory? _category;
  PropertySubType?  _subType;
  RentUnit?         _rentUnit;

  String? _nameErr, _addressErr, _cityErr;

  static const _residentialSubTypes = [
    PropertySubType.flat, PropertySubType.bungalow, PropertySubType.rowHouse,
    PropertySubType.penthouse, PropertySubType.villa, PropertySubType.chawlRoom, PropertySubType.pgRoom,
  ];
  static const _commercialSubTypes = [
    PropertySubType.shop, PropertySubType.officeSpace, PropertySubType.warehouse,
    PropertySubType.showroom, PropertySubType.godown, PropertySubType.factoryUnit,
  ];

  List<RentUnit> get _rentUnitOptions {
    if (_subType == null) return [];
    switch (_subType!) {
      case PropertySubType.pgRoom:   return [RentUnit.bed, RentUnit.room];
      case PropertySubType.rowHouse:
      case PropertySubType.bungalow: return [RentUnit.whole, RentUnit.floor, RentUnit.room];
      case PropertySubType.officeSpace: return [RentUnit.whole, RentUnit.seat];
      case PropertySubType.shop:     return [RentUnit.whole, RentUnit.shopUnit];
      default:                       return [RentUnit.whole];
    }
  }

  bool get _needsUnit => _rentUnit != null && _rentUnit != RentUnit.whole;

  bool _validate() {
    setState(() {
      _nameErr    = _nameCtrl.text.trim().isEmpty    ? 'Property name is required' : null;
      _addressErr = _addressCtrl.text.trim().isEmpty ? 'Address is required'       : null;
      _cityErr    = _cityCtrl.text.trim().isEmpty    ? 'City is required'          : null;
    });
    return _category != null && _subType != null && _rentUnit != null &&
        _nameErr == null && _addressErr == null && _cityErr == null;
  }

  void _submit() {
    if (!_validate()) return;
    final prop = Property(
      id:        DateTime.now().millisecondsSinceEpoch.toString(),
      name:      _nameCtrl.text.trim(),
      address:   _addressCtrl.text.trim(),
      city:      _cityCtrl.text.trim(),
      category:  _category!,
      subType:   _subType!,
      rentUnit:  _rentUnit!,
      unitName:  _needsUnit && _unitCtrl.text.trim().isNotEmpty ? _unitCtrl.text.trim() : null,
      status:    PropertyStatus.vacant,
      imageUrls: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    context.read<PropertyBloc>().add(PropertyAdd(prop));
    context.pop();
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _addressCtrl.dispose(); _cityCtrl.dispose(); _unitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      title: Text('Add Property', style: T.h3),
    ),
    body: SingleChildScrollView(
      padding: S.pageAll,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Category
        Text('Property Type', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: BBRadioCard(
            emoji: '🏠', label: 'Residential',
            selected: _category == PropertyCategory.residential,
            onTap: () => setState(() { _category = PropertyCategory.residential; _subType = null; _rentUnit = null; }),
          )),
          const SizedBox(width: 10),
          Expanded(child: BBRadioCard(
            emoji: '🏢', label: 'Commercial',
            selected: _category == PropertyCategory.commercial,
            onTap: () => setState(() { _category = PropertyCategory.commercial; _subType = null; _rentUnit = null; }),
          )),
        ]),

        // Sub-type
        if (_category != null) ...[
          const SizedBox(height: 16),
          Text('Sub Type', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: (
            _category == PropertyCategory.residential ? _residentialSubTypes : _commercialSubTypes
          ).map((st) => BBOptionChip(
            label: st.label,
            selected: _subType == st,
            onTap: () => setState(() { _subType = st; _rentUnit = null; }),
          )).toList()),
        ],

        // Rent unit
        if (_subType != null && _rentUnitOptions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('What is on Rent', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: _rentUnitOptions.map((ru) => BBOptionChip(
            label: ru.label,
            selected: _rentUnit == ru,
            onTap: () => setState(() => _rentUnit = ru),
          )).toList()),
        ],

        // Unit name
        if (_needsUnit) ...[
          const SizedBox(height: 16),
          BBTextField(label: 'Unit / Room Name (optional)', hint: 'e.g. Room 1, Bed A', controller: _unitCtrl),
        ],

        const SizedBox(height: 20),
        BBCard(child: Column(children: [
          BBTextField(label: 'Property Name *', hint: 'e.g. Sharma House', controller: _nameCtrl, error: _nameErr),
          const SizedBox(height: 12),
          BBTextField(label: 'Address *', hint: 'Street address', controller: _addressCtrl, error: _addressErr, maxLines: 2),
          const SizedBox(height: 12),
          BBTextField(label: 'City *', hint: 'e.g. Mumbai', controller: _cityCtrl, error: _cityErr),
        ])),

        const SizedBox(height: 24),
        BBButton.primary(label: 'ADD PROPERTY', onPressed: _submit),
        const SizedBox(height: 24),
      ]),
    ),
  );
}
