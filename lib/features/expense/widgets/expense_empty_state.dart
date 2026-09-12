import 'package:flutter/material.dart';
import 'package:pulse/core/app_colors.dart';

class ExpenseEmptyState extends StatelessWidget {
  const ExpenseEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            color: AppColors.primaryColor,
            size: 38,
          ),
          const SizedBox(height: 10),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          const Text(
            'Your recorded expenses will appear here.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
