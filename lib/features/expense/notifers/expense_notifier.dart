import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/services/expense_service.dart';

final expenseServiceProvider = Provider<ExpenseService>((ref) {
  return ExpenseService(dio: GetIt.instance());
});

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, List<Expense>>(ExpenseNotifier.new);

class ExpenseNotifier extends AsyncNotifier<List<Expense>> {
  ExpenseService get _expenseService => ref.read(expenseServiceProvider);

  @override
  Future<List<Expense>> build() => _expenseService.fetchAll();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_expenseService.fetchAll);
  }

  Future<void> createExpense(Expense expense) async {
    final currentExpenses = state.value ?? [];
    state = const AsyncLoading();
    try {
      final createdExpense = await _expenseService.createExpense(expense);
      state = AsyncData([...currentExpenses, createdExpense]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    final currentExpenses = state.value ?? [];
    state = const AsyncLoading();
    try {
      final updatedExpense = await _expenseService.updateExpense(expense);
      state = AsyncData([
        for (final currentExpense in currentExpenses)
          if (currentExpense.id == updatedExpense.id)
            updatedExpense
          else
            currentExpense,
      ]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> deleteExpense(String id) async {
    final currentExpenses = state.value ?? [];
    state = const AsyncLoading();
    try {
      await _expenseService.deleteExpense(id);
      state = AsyncData(
        currentExpenses
            .where((expense) => expense.id != id)
            .toList(growable: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
