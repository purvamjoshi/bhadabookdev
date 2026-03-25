import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/domain/core/extensions/format_extension.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/core/widgets/bb_card.dart';
import 'package:bhadabook/presentation/core/widgets/bb_progress_bar.dart';
import 'package:bhadabook/application/agreement/bloc/agreement_bloc.dart';

class AgreementStep3Screen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const AgreementStep3Screen({super.key, required this.extra});
  @override State<AgreementStep3Screen> createState() => _State();
}

class _State extends State<AgreementStep3Screen> {
  DateTime? _startDate, _moveInDate, _endDate;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final draft = context.read<AgreementBloc>().state.draft;
      setState(() {
        _startDate  = draft.startDate;
        _moveInDate = draft.moveInDate;
        _endDate    = draft.endDate;
      });
    }
  }

  Future<void> _pickDate(BuildContext ctx, {required String field}) async {
    final now    = DateTime.now();
    final init   = field == 'start'  ? (_startDate ?? now)
                 : field == 'movein' ? (_moveInDate ?? now)
                 : (_endDate ?? now.add(const Duration(days: 365)));
    final picked = await showDatePicker(
      context: ctx, initialDate: init,
      firstDate: DateTime(2020), lastDate: DateTime(2035),
    );
    if (picked == null) return;
    setState(() {
      if (field == 'start')  _startDate  = picked;
      if (field == 'movein') _moveInDate = picked;
      if (field == 'end')    _endDate    = picked;
    });
  }

  void _submit() {
    if (_startDate == null || _moveInDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select all dates')));
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End date must be after start date')));
      return;
    }
    context.read<AgreementBloc>().add(AgreementStep3Done(start: _startDate!, moveIn: _moveInDate!, end: _endDate!));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra['edit'] == true;
    return BlocListener<AgreementBloc, AgreementState>(
      listener: (ctx, s) {
        if (s.status == AgreementStatus2.success) {
          ctx.read<AgreementBloc>().add(AgreementReset());
          if (isEdit) {
            navigator<NavigationService>().goBack();
            navigator<NavigationService>().goBack();
            navigator<NavigationService>().goBack();
          } else {
            navigator<NavigationService>().pushAndRemoveAll(AppRoutes.agreementSuccess);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.white, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => navigator<NavigationService>().goBack()),
          title: Text(isEdit ? 'Edit Agreement' : 'New Agreement', style: T.h3),
        ),
        body: BlocBuilder<AgreementBloc, AgreementState>(builder: (_, s) => SingleChildScrollView(
          padding: S.pageAll,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!isEdit) ...[BBStepBar(step: 3, total: 3), const SizedBox(height: 20)],
            Text('Agreement Dates', style: T.h3),
            const SizedBox(height: 4),
            Text('Set the agreement period and move-in date', style: T.caption.copyWith(color: AppColors.slate)),
            const SizedBox(height: 16),

            BBCard(child: Column(children: [
              _DateField(
                label: 'Agreement Start Date *',
                value: _startDate,
                onTap: () => _pickDate(context, field: 'start'),
              ),
              const SizedBox(height: 12),
              _DateField(
                label: 'Move-In Date *',
                value: _moveInDate,
                onTap: () => _pickDate(context, field: 'movein'),
              ),
              const SizedBox(height: 12),
              _DateField(
                label: 'Agreement End Date *',
                value: _endDate,
                onTap: () => _pickDate(context, field: 'end'),
              ),
            ])),

            if (_startDate != null && _endDate != null && _endDate!.isAfter(_startDate!)) ...[
              const SizedBox(height: 12),
              BBCard(child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text('Duration: ${_months(_startDate!, _endDate!)} months', style: T.bodySmMd.copyWith(color: AppColors.primary)),
              ])),
            ],

            const SizedBox(height: 24),
            BBButton.primary(
              label: isEdit ? 'SAVE CHANGES' : 'CREATE AGREEMENT',
              onPressed: s.status == AgreementStatus2.loading ? null : _submit,
              isLoading: s.status == AgreementStatus2.loading,
            ),
            const SizedBox(height: 24),
          ]),
        )),
      ),
    );
  }

  int _months(DateTime from, DateTime to) => ((to.year - from.year) * 12 + to.month - from.month).clamp(0, 999);
}

class _DateField extends StatelessWidget {
  final String label; final DateTime? value; final VoidCallback onTap;
  const _DateField({required this.label, this.value, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: value != null ? AppColors.primary : AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: T.caption.copyWith(color: AppColors.slate, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value != null ? Fmt.date(value!) : 'Tap to select', style: T.bodySm.copyWith(color: value != null ? AppColors.navy : AppColors.grey400)),
        ])),
        Icon(Icons.calendar_today_outlined, size: 18, color: value != null ? AppColors.primary : AppColors.grey400),
      ]),
    ),
  );
}
