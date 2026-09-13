import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/features/expense/notifers/expense_notifier.dart';
import 'package:pulse/features/expense/services/expense_service.dart';

import 'expense_notifier_test.mocks.dart';

@GenerateMocks([ExpenseService])
void main() {
  final baseDate = DateTime(2026, 9, 13);

  Expense makeExpense({
    String id = 'e1',
    String title = 'Lunch',
    int amountKobo = 150000,
  }) {
    return Expense(
      id: id,
      title: title,
      amountKobo: amountKobo,
      category: ExpenseCategory.food,
      createdAt: baseDate,
    );
  }

  late MockExpenseService mockService;
  late ProviderContainer container;

  setUp(() {
    mockService = MockExpenseService();
    container = ProviderContainer(
      overrides: [expenseServiceProvider.overrideWithValue(mockService)],
    );
    addTearDown(container.dispose);
  });

  group('ExpenseNotifier', () {
    test('createExpense appends to list', () async {
      final existing = makeExpense(id: 'e1');
      final created = makeExpense(id: 'e2', title: 'New');

      when(mockService.fetchAll()).thenAnswer((_) async => [existing]);
      when(mockService.createExpense(any)).thenAnswer((_) async => created);

      await container.read(expenseNotifierProvider.future);
      await container
          .read(expenseNotifierProvider.notifier)
          .createExpense(created);

      final expenses = container.read(expenseNotifierProvider).value!.expenses;
      expect(expenses.length, equals(2));
      expect(expenses.any((e) => e.id == 'e2'), isTrue);
    });

    test('updateExpense replaces the existing item, not appends', () async {
      final original = makeExpense(id: 'e1', title: 'Old', amountKobo: 100000);
      final updated = original.copyWith(title: 'New', amountKobo: 200000);

      when(mockService.fetchAll()).thenAnswer((_) async => [original]);
      when(mockService.updateExpense(any)).thenAnswer((_) async => updated);

      await container.read(expenseNotifierProvider.future);
      await container
          .read(expenseNotifierProvider.notifier)
          .updateExpense(updated);

      final expenses = container.read(expenseNotifierProvider).value!.expenses;
      expect(expenses.length, equals(1));
      expect(expenses.first.title, equals('New'));
    });

    test('deleteExpense removes the correct item', () async {
      final keep = makeExpense(id: 'e1', title: 'Keep');
      final remove = makeExpense(id: 'e2', title: 'Remove');

      when(mockService.fetchAll()).thenAnswer((_) async => [keep, remove]);
      when(mockService.deleteExpense('e2')).thenAnswer((_) async {});

      await container.read(expenseNotifierProvider.future);
      await container
          .read(expenseNotifierProvider.notifier)
          .deleteExpense('e2');

      final expenses = container.read(expenseNotifierProvider).value!.expenses;
      expect(expenses.length, equals(1));
      expect(expenses.first.id, equals('e1'));
    });
  });
}
