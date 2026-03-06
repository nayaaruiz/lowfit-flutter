import 'package:flutter/material.dart';
import 'package:flutter_lowfit/core/models/trainer_response.dart';

class TrainersList extends StatelessWidget {
  final List<Trainer> trainers;
  final VoidCallback? onSeeAll;
  final void Function(Trainer trainer)? onTrainerTap;

  const TrainersList({
    super.key,
    required this.trainers,
    this.onSeeAll,
    this.onTrainerTap,
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
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (trainers.isEmpty)
          const Text(
            'No hay entrenadores disponibles',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          )
        else
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: trainers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final trainer = trainers[index];
                final initial = trainer.name.isNotEmpty
                    ? trainer.name[0].toUpperCase()
                    : '?';

                return GestureDetector(
                  onTap: () => onTrainerTap?.call(trainer),
                  child: SizedBox(
                    width: 70,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFF3A3A66),
                          backgroundImage: trainer.photo.isNotEmpty
                              ? NetworkImage(trainer.photo)
                              : null,
                          child: trainer.photo.isEmpty
                              ? Text(
                                  initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trainer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}