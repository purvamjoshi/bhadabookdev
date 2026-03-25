import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/bb_button.dart';
import '../../../../../core/widgets/bb_card.dart';
import '../../../../../core/widgets/bb_progress_bar.dart';
import '../../../../../core/widgets/bb_text_field.dart';
import '../../../../../mock/mock_data.dart';
import '../bloc/agreement_bloc.dart';

class AgreementStep1Screen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const AgreementStep1Screen({super.key, required this.extra});
  @override State<AgreementStep1Screen> createState() => _State();
}

class _State extends State<AgreementStep1Screen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  String? _nameErr, _phoneErr;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      context.read<AgreementBloc>().add(AgreementInit(widget.extra));
      final draft = context.read<AgreementBloc>().state.draft;
      if (draft.tenantName != null) {
        _nameCtrl.text    = draft.tenantName!;
        _phoneCtrl.text   = draft.tenantPhone?.replaceAll('+91', '') ?? '';
        _addressCtrl.text = draft.tenantAddress ?? '';
      }
    }
  }

  bool _validate() {
    setState(() {
      _nameErr  = _nameCtrl.text.trim().isEmpty ? 'Name is required' : null;
      _phoneErr = _phoneCtrl.text.trim().length != 10 ? 'Enter valid 10-digit number' : null;
    });
    return _nameErr == null && _phoneErr == null;
  }

  void _next() {
    if (!_validate()) return;
    context.read<AgreementBloc>().add(AgreementStep1Done(
      name:    _nameCtrl.text.trim(),
      phone:   '+91${_phoneCtrl.text.trim()}',
      address: _addressCtrl.text.trim(),
    ));
    context.push('/agreement/step2', extra: widget.extra);
  }

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); _addressCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra['edit'] == true;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        title: Text(isEdit ? 'Edit Agreement' : 'New Agreement', style: T.h3),
      ),
      body: SingleChildScrollView(
        padding: S.pageAll,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!isEdit) ...[BBStepBar(current: 0, total: 3), const SizedBox(height: 20)],
          Text('Tenant Details', style: T.h3),
          const SizedBox(height: 4),
          Text('Enter the tenant\'s personal information', style: T.caption.copyWith(color: AppColors.slate)),
          const SizedBox(height: 16),

          // Existing tenant picker if applicable
          if (widget.extra['existing'] == true) ...[
            BBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Select Existing Tenant', style: T.bodyMd.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...mockTenants.map((t) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: AppColors.primarySurface,
                  child: Text(t.initials, style: T.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
                title: Text(t.name, style: T.bodySm),
                subtitle: Text(t.phone, style: T.caption),
                onTap: () {
                  _nameCtrl.text    = t.name;
                  _phoneCtrl.text   = t.phone.replaceAll('+91', '');
                  _addressCtrl.text = t.permanentAddress;
                  context.read<AgreementBloc>().add(AgreementInit({...widget.extra, 'tenantId': t.id, 'isNewTenant': false}));
                  setState(() {});
                },
              )),
            ])),
            const SizedBox(height: 16),
          ],

          BBCard(child: Column(children: [
            BBTextField(label: 'Full Name *', hint: 'e.g. Ravi Sharma', controller: _nameCtrl, error: _nameErr),
            const SizedBox(height: 12),
            BBTextField(
              label: 'Mobile Number *', hint: '9876543210',
              controller: _phoneCtrl, error: _phoneErr,
              keyboard: TextInputType.phone, maxLen: 10, prefixText: '+91',
            ),
            const SizedBox(height: 12),
            BBTextField(label: 'Permanent Address', hint: 'Street, City, State, PIN', controller: _addressCtrl, maxLines: 3),
          ])),

          const SizedBox(height: 24),
          BBButton.primary(label: 'NEXT: RENT DETAILS →', onPressed: _next),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
