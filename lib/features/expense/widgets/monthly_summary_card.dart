import 'package:flutter/material.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/core/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({required this.totalKobo, super.key});

  final int totalKobo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Skeleton.keep(
            child: Text('TOTAL SPENT', style: TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 8),
          Text(
            (totalKobo / 100).toNaira(),
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Skeleton.keep(
            child: Text(
              'Disbursed across this month’s expenses',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
