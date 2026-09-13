import 'package:flutter/material.dart';
import 'package:pulse/core/app_colors.dart';

class RecentExpensesHeader extends StatelessWidget {
  const RecentExpensesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Recent Expenses',
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Text(
          'View All',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: AppColors.primaryColor,
          size: 16,
        ),
      ],
    );
  }
}
