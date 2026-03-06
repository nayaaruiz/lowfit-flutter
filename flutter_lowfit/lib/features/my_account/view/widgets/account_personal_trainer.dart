import 'package:flutter/material.dart';

class AccountPersonalTrainersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> trainers;

  const AccountPersonalTrainersWidget({
    super.key,
    required this.trainers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Personal trainers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: trainers.map((trainer) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _TrainerAvatarWidget(
                name: trainer['name'] as String,
                color: trainer['color'] as Color,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TrainerAvatarWidget extends StatelessWidget {
  final String name;
  final Color color;

  const _TrainerAvatarWidget({
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.25),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              name[0],
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}