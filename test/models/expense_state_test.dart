import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/models/expense_state.dart';

void main() {
  Expense makeExpense(String title, int amountKobo, DateTime createdAt) {
    return Expense(
      title: title,
      amountKobo: amountKobo,
      category: ExpenseCategory.other,
      createdAt: createdAt,
    );
  }

  group('ExpenseState', () {
    test('total sums all expenses', () {
      final state = ExpenseState([
        makeExpense('A', 100000, DateTime(2026, 9, 1)),
        makeExpense('B', 250000, DateTime(2026, 9, 2)),
        makeExpense('C', 75000, DateTime(2026, 9, 3)),
      ]);
      expect(state.total, equals(425000));
    });

    test('expenses are sorted newest first', () {
      final state = ExpenseState([
        makeExpense('Oldest', 1000, DateTime(2026, 9, 1)),
        makeExpense('Newest', 1000, DateTime(2026, 9, 10)),
        makeExpense('Middle', 1000, DateTime(2026, 9, 5)),
      ]);
      expect(
        state.expenses.map((e) => e.title).toList(),
        equals(['Newest', 'Middle', 'Oldest']),
      );
    });
  });
}
