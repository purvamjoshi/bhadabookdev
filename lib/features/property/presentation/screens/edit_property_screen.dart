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
import '../../../../mock/mock_data.dart';
import '../../domain/entities/property.dart';
import '../bloc/property_bloc.dart';

class EditPropertyScreen extends StatefulWidget {
  final String propertyId;
  const EditPropertyScreen({super.key, required this.propertyId});
  @override State<EditPropertyScreen> createState() => _State();
}

class _State extends State<EditPropertyScreen> {
  late final TextEditingController _nameCtrl, _addressCtrl, _cityCtrl, _unitCtrl;
  late PropertyCategory _category;
  late PropertySubType  _subType;
  late RentUnit         _rentUnit;
  String? _nameErr, _addressErr, _cityErr;

  Property? get _prop => mockProperties.where((p) => p.id == widget.propertyId).firstOrNull;

  static const _residentialSubTypes = [
    PropertySubType.flat, PropertySubType.bungalow, PropertySubType.rowHouse,
    PropertySubType.penthouse, PropertySubType.villa, PropertySubType.chawlRoom, PropertySubType.pgRoom,
  ];
  static const _commercialSubTypes = [
    PropertySubType.shop, PropertySubType.officeSpace, PropertySubType.warehouse,
    PropertySubType.showroom, PropertySubType.godown, PropertySubType.factoryUnit,
  ];

  List<RentUnit> get _rentUnitOptions {
    switch (_subType) {
      case PropertySubType.pgRoom:      return [RentUnit.bed, RentUnit.room];
      case PropertySubType.rowHouse:
      case PropertySubType.bungalow:    return [RentUnit.whole, RentUnit.floor, RentUnit.room];
      case PropertySubType.officeSpace: return [RentUnit.whole, RentUnit.seat];
      case PropertySubType.shop:        return [RentUnit.whole, RentUnit.shopUnit];
      default:                          return [RentUnit.whole];
    }
  }

  bool get _needsUnit => _rentUnit != RentUnit.whole;

  @override
  void initState() {
    super.initState();
    final p = _prop;
    _nameCtrl    = TextEditingController(text: p?.name     ?? '');
    _addressCtrl = TextEditingController(text: p?.address  ?? '');
    _cityCtrl    = TextEditingController(text: p?.city     ?? '');
    _unitCtrl    = TextEditingController(text: p?.unitName ?? '');
    _category    = p?.category ?? PropertyCategory.residential;
    _subType     = p?.subType  ?? PropertySubType.flat;
    _rentUnit    = p?.rentUnit ?? RentUnit.whole;
  }

  bool _validate() {
    setState(() {
      _nameErr    = _nameCtrl.text.trim().isEmpty    ? 'Property name is required' : null;
      _addressErr = _addressCtrl.text.trim().isEmpty ? 'Address is required'       : null;
      _cityErr    = _cityCtrl.text.trim().isEmpty    ? 'City is required'          : null;
    });
    return _nameErr == null && _addressErr == null && _cityErr == null;
  }

  void _submit() {
    if (!_validate()) return;
    final original = _prop;
    if (original == null) return;
    final updated = original.copyWith(
      name:     _nameCtrl.text.trim(),
      address:  _addressCtrl.text.trim(),
      city:     _cityCtrl.text.trim(),
      category: _category,
      subType:  _subType,
      rentUnit: _rentUnit,
      unitName: _needsUnit && _unitCtrl.text.trim().isNotEmpty ? _unitCtrl.text.trim() : null,
    );
    context.read<PropertyBloc>().add(PropertyUpdate(updated));
    context.pop();
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _addressCtrl.dispose(); _cityCtrl.dispose(); _unitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_prop == null) return const Scaffold(body: Center(child: Text('Property not found')));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        title: Text('Edit Property', style: T.h3),
      ),
      body: SingleChildScrollView(
        padding: S.pageAll,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Property Type', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: BBRadioCard(
              emoji: '🏠', label: 'Residential',
              selected: _category == PropertyCategory.residential,
              onTap: () => setState(() {
                _category = PropertyCategory.residential;
                _subType  = PropertySubType.flat;
                _rentUnit = RentUnit.whole;
              }),
            )),
            const SizedBox(width: 10),
            Expanded(child: BBRadioCard(
              emoji: '🏢', label: 'Commercial',
              selected: _category == PropertyCategory.commercial,
              onTap: () => setState(() {
                _category = PropertyCategory.commercial;
                _subType  = PropertySubType.shop;
                _rentUnit = RentUnit.whole;
              }),
            )),
          ]),
          const SizedBox(height: 16),
          Text('Sub Type', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: (
            _category == PropertyCategory.residential ? _residentialSubTypes : _commercialSubTypes
          ).map((st) => BBOptionChip(
            label: st.label,
            selected: _subType == st,
            onTap: () => setState(() {
              _subType  = st;
              _rentUnit = (switch (st) {
                PropertySubType.pgRoom      => RentUnit.room,
                PropertySubType.officeSpace => RentUnit.whole,
                PropertySubType.shop        => RentUnit.whole,
                _                           => RentUnit.whole,
              });
            }),
          )).toList()),
          const SizedBox(height: 16),
          Text('What is on Rent', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: _rentUnitOptions.map((ru) => BBOptionChip(
            label: ru.label,
            selected: _rentUnit == ru,
            onTap: () => setState(() => _rentUnit = ru),
          )).toList()),
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
          BBButton.primary(label: 'SAVE CHANGES', onPressed: _submit),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
