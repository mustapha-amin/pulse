import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/core/extensions.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/notifers/expense_notifier.dart';
import 'package:pulse/features/expense/views/expense_form_screen.dart';
import 'package:pulse/features/expense/widgets/expense_detail_row.dart';

class ExpenseDetailsScreen extends ConsumerStatefulWidget {
  const ExpenseDetailsScreen({required this.expense, super.key});

  final Expense expense;

  @override
  ConsumerState<ExpenseDetailsScreen> createState() =>
      _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends ConsumerState<ExpenseDetailsScreen> {
  var _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final expense = widget.expense;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            onPressed: _isDeleting ? null : _editExpense,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit expense',
          ),
          IconButton(
            onPressed: expense.id == null || _isDeleting
                ? null
                : _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete expense',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL PAID',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expense.amountNaira.toNaira(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMMM y').format(expense.createdAt),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ExpenseDetailRow(
                    icon: Icons.receipt_long_outlined,
                    label: 'Title',
                    value: expense.title,
                  ),
                  const Divider(height: 1),
                  ExpenseDetailRow(
                    icon: Icons.category_outlined,
                    label: 'Category',
                    value: expense.category.label,
                  ),
                  const Divider(height: 1),
                  ExpenseDetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: DateFormat('EEE, d MMM y').format(expense.createdAt),
                  ),
                ],
              ),
            ),
            if (_isDeleting) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editExpense() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ExpenseFormScreen(expense: widget.expense),
      ),
    );
    if (updated == true && mounted) Navigator.pop(context, true);
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await ref
          .read(expenseNotifierProvider.notifier)
          .deleteExpense(widget.expense.id!);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete expense: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }
}
