import 'package:pulse/features/expense/models/expense.dart';

/// Fixture data that gives Skeletonizer the same dashboard shape as loaded data.
final expenseLoadingPlaceholders = List<Expense>.unmodifiable([
  Expense(
    title: 'Electricity bill',
    amountKobo: 450000,
    category: ExpenseCategory.bills,
    createdAt: DateTime(2026, 9, 12),
  ),
  Expense(
    title: 'Uber ride to Victoria Island',
    amountKobo: 320000,
    category: ExpenseCategory.transport,
    createdAt: DateTime(2026, 9, 11),
  ),
  Expense(
    title: 'Lunch at Terra Kulture',
    amountKobo: 280000,
    category: ExpenseCategory.food,
    createdAt: DateTime(2026, 9, 10),
  ),
  Expense(
    title: 'Weekly groceries',
    amountKobo: 150000,
    category: ExpenseCategory.other,
    createdAt: DateTime(2026, 9, 8),
  ),
]);
