import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/core/extensions.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/notifers/expense_notifier.dart';
import 'package:pulse/features/expense/views/expense_details_screen.dart';
import 'package:pulse/features/expense/views/expense_form_screen.dart';
import 'package:pulse/features/expense/widgets/expense_empty_state.dart';
import 'package:pulse/features/expense/widgets/expense_load_error.dart';
import 'package:pulse/features/expense/widgets/expense_list_tile.dart';
import 'package:pulse/features/expense/widgets/expense_loading_skeleton.dart';
import 'package:pulse/features/expense/widgets/monthly_summary_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expenseNotifierProvider);
    final expenses = expensesState.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: Row(
          spacing: 4,
          children: [
            Image.asset('assets/app_icon.png', width: 40, height: 40, fit: BoxFit.contain),
            Text('Pulse', style: context.textTheme.titleLarge!.copyWith(fontWeight: .w500)),
          ],
        ),
        backgroundColor: const Color(0xFFF9FAFC),
        surfaceTintColor: Colors.transparent,
        actions: const [
          Icon(Icons.notifications_none_outlined),
          SizedBox(width: 14),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ExpenseFormScreen())),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Add expense',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: switch (expensesState) {
          AsyncError(:final error) when expenses == null => ExpenseLoadError(
            error: error,
            onRetry: () => ref.read(expenseNotifierProvider.notifier).refresh(),
          ),
          _ => _ExpenseDashboard(
            expenses:
                (expensesState.isLoading &&
                    (expenses == null || expenses.isEmpty))
                ? expenseLoadingPlaceholders
                : (expenses ?? expenseLoadingPlaceholders),
            isLoading: expensesState.isLoading,
            onRefresh: () =>
                ref.read(expenseNotifierProvider.notifier).refresh(),
          ),
        },
      ),
    );
  }
}

class _ExpenseDashboard extends StatelessWidget {
  const _ExpenseDashboard({
    required this.expenses,
    required this.isLoading,
    required this.onRefresh,
  });

  final List<Expense> expenses;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final effectiveExpenses = (isLoading && expenses.isEmpty)
        ? expenseLoadingPlaceholders
        : expenses;
    final recentExpenses = [...effectiveExpenses]
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
    final now = DateTime.now();
    final monthExpenses = recentExpenses.where(
      (expense) =>
          expense.createdAt.year == now.year &&
          expense.createdAt.month == now.month,
    );
    final totalKobo = monthExpenses.fold<int>(
      0,
      (total, expense) => total + expense.amountKobo,
    );

    return Skeletonizer(
      enabled: isLoading,
      child: IgnorePointer(
        ignoring: isLoading,
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 104),
            children: [
              Text(
                DateFormat('MMMM y').format(now),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              MonthlySummaryCard(totalKobo: totalKobo),
              const SizedBox(height: 20),
              Row(
      children: [
        Text(
          'Recent Expenses',
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Text(
          'View All',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: AppColors.primaryColor,
          size: 16,
        ),
      ],
    ),
              const SizedBox(height: 10),
              if (!isLoading && recentExpenses.isEmpty)
                const ExpenseEmptyState()
              else
                ...recentExpenses.map(
                  (expense) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ExpenseListTile(
                      expense: expense,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ExpenseDetailsScreen(expense: expense),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
