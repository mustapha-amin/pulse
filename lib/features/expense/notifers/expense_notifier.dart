import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/models/expense_state.dart';
import 'package:pulse/features/expense/services/expense_service.dart';

final expenseServiceProvider = Provider<ExpenseService>((ref) {
  return ExpenseService(dio: GetIt.instance());
});

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, ExpenseState>(ExpenseNotifier.new);

class ExpenseNotifier extends AsyncNotifier<ExpenseState> {
  ExpenseService get _expenseService => ref.read(expenseServiceProvider);

  @override
  Future<ExpenseState> build() async {
    final expenses = await _expenseService.fetchAll();
    return ExpenseState(expenses);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final expenses = await _expenseService.fetchAll();
      return ExpenseState(expenses);
    });
  }

  Future<void> createExpense(Expense expense) async {
    final currentExpenses = state.value;
    state = const AsyncLoading();
    try {
      final createdExpense = await _expenseService.createExpense(expense);
      state = AsyncData(
        currentExpenses!.copyWith(
          expenses: [...currentExpenses.expenses, createdExpense],
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    final currentExpenses = state.value;
    state = const AsyncLoading();
    try {
      final updatedExpense = await _expenseService.updateExpense(expense);
      state = AsyncData(
        currentExpenses!.copyWith(
          expenses: currentExpenses.expenses
              .map((e) => e.id == updatedExpense.id ? updatedExpense : e)
              .toList(),
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> deleteExpense(String id) async {
    final currentExpenses = state.value;
    state = const AsyncLoading();
    try {
      await _expenseService.deleteExpense(id);
      state = AsyncData(
        currentExpenses!.copyWith(
          expenses: currentExpenses.expenses.where((e) => e.id != id).toList(),
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
