import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/expense/views/expense_form_screen.dart';

void main() {
  testWidgets('requires an amount and title before an expense can be saved', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ExpenseFormScreen()),
      ),
    );

    await tester.tap(find.text('Save Expense'));
    await tester.pump();

    expect(find.text('Enter an amount greater than zero'), findsOneWidget);
    expect(find.text('Enter an expense title'), findsOneWidget);
  });
}
