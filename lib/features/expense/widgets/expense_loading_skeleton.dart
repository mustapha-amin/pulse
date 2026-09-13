import 'package:pulse/features/expense/models/expense.dart';

List<Expense> get expenseLoadingPlaceholders {
  final now = DateTime.now();
  return [
    Expense(
      title: 'Electricity bill',
      amountKobo: 450000,
      category: ExpenseCategory.bills,
      createdAt: now,
    ),
    Expense(
      title: 'Uber ride to Victoria Island',
      amountKobo: 320000,
      category: ExpenseCategory.transport,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Expense(
      title: 'Lunch at Terra Kulture',
      amountKobo: 280000,
      category: ExpenseCategory.food,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Expense(
      title: 'Weekly groceries',
      amountKobo: 150000,
      category: ExpenseCategory.other,
      createdAt: now.subtract(const Duration(days: 4)),
    ),
  ];
}

