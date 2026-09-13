import 'package:pulse/features/expense/models/expense.dart';

List<Expense> get expenseLoadingPlaceholders {
  final now = DateTime.now();
  return List.generate(20, (_) {
    return Expense(
      title: 'Electricity bill',
      amountKobo: 450000,
      category: ExpenseCategory.bills,
      createdAt: now,
    );
  });
}
