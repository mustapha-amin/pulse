import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/expense/models/expense.dart';

void main() {
  final baseDate = DateTime(2026, 9, 13);

  group('Expense', () {
    test('throws on empty title', () {
      expect(
        () => Expense(
          title: '   ',
          amountKobo: 100,
          category: ExpenseCategory.food,
          createdAt: baseDate,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws on non-positive amount', () {
      expect(
        () => Expense(
          title: 'Lunch',
          amountKobo: 0,
          category: ExpenseCategory.food,
          createdAt: baseDate,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('amountNaira divides kobo by 100', () {
      final expense = Expense(
        title: 'Lunch',
        amountKobo: 150000,
        category: ExpenseCategory.food,
        createdAt: baseDate,
      );
      expect(expense.amountNaira, equals(1500.0));
    });

    test('fromJson round-trips correctly', () {
      final json = {
        '_id': 'abc123',
        'title': 'Electricity',
        'amountKobo': 450000,
        'category': 'bills',
        'createdAt': baseDate.toIso8601String(),
      };
      final expense = Expense.fromJson(json);

      expect(expense.id, 'abc123');
      expect(expense.title, 'Electricity');
      expect(expense.amountKobo, 450000);
      expect(expense.category, ExpenseCategory.bills);
      expect(expense.createdAt, baseDate);
    });

    test('toJson omits id', () {
      final expense = Expense(
        id: 'server-id',
        title: 'Lunch',
        amountKobo: 10000,
        category: ExpenseCategory.food,
        createdAt: baseDate,
      );
      expect(expense.toJson().containsKey('id'), isFalse);
    });
  });
}
