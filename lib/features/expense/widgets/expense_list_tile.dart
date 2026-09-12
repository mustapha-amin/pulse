import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/extensions.dart';
import 'package:pulse/features/expense/models/expense.dart';

class ExpenseListTile extends StatelessWidget {
  const ExpenseListTile({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final categoryStyle = _categoryStyles[expense.category]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: categoryStyle.color,
            child: Icon(
              categoryStyle.icon,
              size: 16,
              color: categoryStyle.iconColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: categoryStyle.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        child: Text(
                          expense.category.name.toUpperCase(),
                          style: TextStyle(
                            color: categoryStyle.iconColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        DateFormat('d MMM y').format(expense.createdAt),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            (expense.amountKobo / 100).toNaira(),
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9AA4B2)),
        ],
      ),
    );
  }
}

class _CategoryStyle {
  const _CategoryStyle(this.icon, this.color, this.iconColor);

  final IconData icon;
  final Color color;
  final Color iconColor;
}

const _categoryStyles = <ExpenseCategory, _CategoryStyle>{
  ExpenseCategory.food: _CategoryStyle(
    Icons.restaurant,
    Color(0xFFC8F6F0),
    Color(0xFF0D8C7B),
  ),
  ExpenseCategory.transport: _CategoryStyle(
    Icons.directions_car,
    Color(0xFFDDE4FF),
    Color(0xFF3B5CC4),
  ),
  ExpenseCategory.bills: _CategoryStyle(
    Icons.bolt,
    Color(0xFFE8E9FF),
    Color(0xFF4A59C8),
  ),
  ExpenseCategory.other: _CategoryStyle(
    Icons.more_horiz,
    Color(0xFFE8EBF0),
    Color(0xFF657080),
  ),
};
