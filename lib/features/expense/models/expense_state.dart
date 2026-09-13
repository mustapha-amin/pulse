// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pulse/features/expense/models/expense.dart';

class ExpenseState {
  final List<Expense> _expenses;

  ExpenseState(this._expenses);


  List<Expense> get expenses =>
      _expenses
        ..sort((first, second) => second.createdAt.compareTo(first.createdAt));

  int get total =>
      expenses.fold<int>(0, (total, expense) => total + expense.amountKobo);

  ExpenseState copyWith({
    List<Expense>? expenses,
  }) {
    return ExpenseState(
      expenses ?? _expenses,
    );
  }
}
