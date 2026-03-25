import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/tenant/models/tenant_dto.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_card.dart';
import 'package:bhadabook/presentation/core/widgets/bb_text_field.dart';
import 'package:bhadabook/application/tenant/bloc/tenant_bloc.dart';

class AddTenantScreen extends StatefulWidget {
  /// Optional propertyId — pre-links tenant if provided
  final String? propertyId;
  const AddTenantScreen({super.key, this.propertyId});
  @override State<AddTenantScreen> createState() => _State();
}

class _State extends State<AddTenantScreen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  String? _nameErr, _phoneErr;

  bool _validate() {
    setState(() {
      _nameErr  = _nameCtrl.text.trim().isEmpty ? 'Name is required' : null;
      _phoneErr = _phoneCtrl.text.trim().length != 10 ? 'Enter valid 10-digit number' : null;
    });
    return _nameErr == null && _phoneErr == null;
  }

  void _submit() {
    if (!_validate()) return;
    final tenant = Tenant(
      id:                 DateTime.now().millisecondsSinceEpoch.toString(),
      name:               _nameCtrl.text.trim(),
      phone:              '+91${_phoneCtrl.text.trim()}',
      permanentAddress:   _addressCtrl.text.trim(),
      identityProofUrls:  [],
      currentPropertyId:  widget.propertyId,
      createdAt:          DateTime.now(),
      updatedAt:          DateTime.now(),
    );
    context.read<TenantBloc>().add(TenantAdd(tenant));
    navigator<NavigationService>().goBack();
  }

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); _addressCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: AppColors.white, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().goBack()),
      title: Text('Add Tenant', style: T.h3),
    ),
    body: SingleChildScrollView(
      padding: S.pageAll,
      child: Column(children: [
        BBCard(child: Column(children: [
          BBTextField(label: 'Full Name *', hint: 'e.g. Ravi Sharma', controller: _nameCtrl, error: _nameErr),
          const SizedBox(height: 12),
          BBTextField(
            label: 'Mobile Number *', hint: '9876543210', controller: _phoneCtrl, error: _phoneErr,
            keyboard: TextInputType.phone, maxLen: 10, prefixText: '+91',
          ),
          const SizedBox(height: 12),
          BBTextField(label: 'Permanent Address', hint: 'Street, City, State, PIN', controller: _addressCtrl, maxLines: 3),
        ])),
        const SizedBox(height: 24),
        BBButton.primary(label: 'ADD TENANT', onPressed: _submit),
        const SizedBox(height: 24),
      ]),
    ),
  );
}
