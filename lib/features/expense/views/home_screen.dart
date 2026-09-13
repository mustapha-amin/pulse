import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/core/extensions.dart';
import 'package:pulse/core/theme_notifier.dart';
import 'package:pulse/features/expense/notifers/expense_notifier.dart';
import 'package:pulse/features/expense/views/expense_details_screen.dart';
import 'package:pulse/features/expense/views/expense_form_screen.dart';
import 'package:pulse/features/expense/widgets/expense_empty_state.dart';
import 'package:pulse/features/expense/widgets/expense_list_tile.dart';
import 'package:pulse/features/expense/widgets/expense_load_error.dart';
import 'package:pulse/features/expense/widgets/expense_loading_skeleton.dart';
import 'package:pulse/features/expense/widgets/monthly_summary_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expenseNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = expensesState.isLoading;

    final totalKobo = expensesState.maybeWhen(
      data: (data) => data.total,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 4,
          children: [
            Image.asset(
              'assets/app_icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            Text(
              'Pulse',
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light mode' : 'Switch to Dark mode',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.notifications_none_outlined),
          const SizedBox(width: 14),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 16),
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
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () => ref.read(expenseNotifierProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 104),
            children: [
              Skeleton.keep(
                child: Text(
                  DateFormat('MMMM y').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              Skeletonizer(
                enabled: isLoading,
                effect: AppColors.skeletonEffect(isDark: isDark),
                child: MonthlySummaryCard(totalKobo: totalKobo),
              ),
              const SizedBox(height: 20),
              Skeleton.keep(
                child: Row(
                  children: [
                    Text(
                      'All Expenses',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...expensesState.when(
                data: (data) {
                  if (data.expenses.isEmpty) {
                    return const [ExpenseEmptyState()];
                  }
                  return data.expenses.map(
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
                  );
                },
                error: (error, _) => [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: ExpenseLoadError(
                      error: error,
                      onRetry: () =>
                          ref.read(expenseNotifierProvider.notifier).refresh(),
                    ),
                  ),
                ],
                loading: () => [
                  Skeletonizer(
                    enabled: true,
                    effect: AppColors.skeletonEffect(isDark: isDark),
                    child: Column(
                      children: expenseLoadingPlaceholders
                          .map(
                            (expense) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ExpenseListTile(
                                expense: expense,
                                onTap: () {},
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
