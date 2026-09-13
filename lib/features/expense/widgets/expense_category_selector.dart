import 'package:flutter/material.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/features/expense/models/expense.dart';

class ExpenseCategorySelector extends StatelessWidget {
  const ExpenseCategorySelector({
    required this.selectedCategory,
    required this.onChanged,
    super.key,
  });

  final ExpenseCategory selectedCategory;
  final ValueChanged<ExpenseCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ExpenseCategory.values.map((category) {
        final isSelected = category == selectedCategory;
        return ChoiceChip(
          selected: isSelected,
          onSelected: (_) => onChanged(category),
          showCheckmark: false,
          avatar: Icon(
            category.icon,
            size: 18,
            color: isSelected
                ? AppColors.primaryColor
                : Theme.of(context).iconTheme.color ?? Colors.grey[800],
          ),
          label: Text(category.label),
          selectedColor: AppColors.primaryColor.withValues(alpha: 0.16),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryColor : null,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : Colors.blueGrey,
          ),
        );
      }).toList(),
    );
  }
}
