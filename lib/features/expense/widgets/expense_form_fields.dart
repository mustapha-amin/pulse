import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/core/extensions.dart';

class ExpenseAmountField extends StatefulWidget {
  const ExpenseAmountField({
    required this.controller,
    required this.onQuickAdd,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<int> onQuickAdd;

  @override
  State<ExpenseAmountField> createState() => _ExpenseAmountFieldState();
}

class _ExpenseAmountFieldState extends State<ExpenseAmountField> {
  int? selectedAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Amount (NGN) *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            ThousandsFormatter(allowFraction: true),
          ],
          decoration: const InputDecoration(prefixText: 'NGN  '),
          validator: (value) {
            final cleanText = value?.replaceAll(',', '').trim() ?? '';
            final amount = double.tryParse(cleanText);
            if (amount == null || amount <= 0) {
              return 'Enter an amount greater than zero';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [500, 1000, 5000]
              .map(
                (amount) => ActionChip(
                  color: WidgetStatePropertyAll(selectedAmount == amount ? AppColors.primaryColor : Colors.white),
                  label: Text(amount.toNaira(), style: context.textTheme.bodyMedium!.copyWith(
                    color: selectedAmount == amount ? Colors.white :Colors.black
                  ),),
                  onPressed: () {
                    widget.onQuickAdd(amount);
                    setState(() {
                      selectedAmount = amount;
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ExpenseDateField extends StatelessWidget {
  const ExpenseDateField({
    required this.date,
    required this.onPressed,
    super.key,
  });

  final DateTime date;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date *'),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.calendar_today_outlined, size: 18),
          label: Text(DateFormat('EEE, d MMM y').format(date)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            minimumSize: const Size.fromHeight(50),
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }
}
