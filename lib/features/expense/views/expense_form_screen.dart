import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/notifers/expense_notifier.dart';
import 'package:pulse/features/expense/widgets/expense_category_selector.dart';
import 'package:pulse/features/expense/widgets/expense_form_fields.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({this.expense, super.key});

  final Expense? expense;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _titleController;
  late ExpenseCategory _category;
  late DateTime _date;
  var _hasSubmitted = false;

  bool get _isEditing => widget.expense != null;

  static String _formatInitialAmount(double amount) {
    if (amount % 1 == 0) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _amountController = TextEditingController(
      text: expense == null ? '' : _formatInitialAmount(expense.amountNaira),
    );
    _titleController = TextEditingController(text: expense?.title ?? '');
    _category = expense?.category ?? ExpenseCategory.food;
    _date = expense?.createdAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseNotifierProvider);
    final isSaving = _hasSubmitted && expenseState.isLoading;

    ref.listen<AsyncValue<List<Expense>>>(expenseNotifierProvider, (
      previous,
      next,
    ) {
      if (!_hasSubmitted || previous?.isLoading != true || !mounted) return;

      next.whenOrNull(
        data: (_) {
          _hasSubmitted = false;
          Navigator.pop(context, true);
        },
        error: (error, _) {
          _hasSubmitted = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not save expense: $error')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Expense' : 'Add Expense'), centerTitle: true,),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ExpenseAmountField(
                controller: _amountController,
                onQuickAdd: _addQuickAmount,
              ),
              const SizedBox(height: 24),
              const Text('Expense title *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                maxLength: 60,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. Fuel for generator',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter an expense title'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text('Category *'),
              const SizedBox(height: 8),
              ExpenseCategorySelector(
                selectedCategory: _category,
                onChanged: (category) => setState(() => _category = category),
              ),
              const SizedBox(height: 24),
              ExpenseDateField(date: _date, onPressed: _selectDate),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: isSaving ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  isSaving
                      ? 'Saving...'
                      : _isEditing
                      ? 'Update Expense'
                      : 'Save Expense',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addQuickAmount(int amount) {
    final formatted = NumberFormat('#,##0').format(amount);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate != null && mounted) setState(() => _date = selectedDate);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cleanAmount = _amountController.text.replaceAll(',', '').trim();
    final parsedAmount = double.tryParse(cleanAmount);
    if (parsedAmount == null) return;

    final expense = Expense(
      id: widget.expense?.id,
      title: _titleController.text.trim(),
      amountKobo: (parsedAmount * 100).round(),
      category: _category,
      createdAt: _date,
    );

    _hasSubmitted = true;
    final notifier = ref.read(expenseNotifierProvider.notifier);
    if (_isEditing) {
      unawaited(notifier.updateExpense(expense));
    } else {
      unawaited(notifier.createExpense(expense));
    }
  }
}
