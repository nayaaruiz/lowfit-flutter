import 'package:flutter/material.dart';
import 'package:flutter_lowfit/features/shared/theme/app_colors.dart';

class MyAccountStatsWidget extends StatelessWidget {
  final int sessionsCompleted;
  final int totalSessions;
  final int classesReserved;
  final int streak;

  const MyAccountStatsWidget({
    super.key,
    required this.sessionsCompleted,
    required this.totalSessions,
    required this.classesReserved,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Personal goal this week',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This week',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Sessions label
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Sessions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$sessionsCompleted Completed',
                style:
                    TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: totalSessions > 0 ? sessionsCompleted / totalSessions : 0,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65), fontSize: 12)),
              Text('$totalSessions',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65), fontSize: 12)),
            ],
          ),

          const SizedBox(height: 16),

          // Mini stats
          Row(
            children: [
              Expanded(
                child: _MiniStatWidget(
                  icon: Icons.calendar_today_outlined,
                  value: '$classesReserved',
                  label: 'Classes booked',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStatWidget(
                  icon: Icons.local_fire_department_outlined,
                  value: '$streak days',
                  label: 'Current streak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStatWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStatWidget({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text(label,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}