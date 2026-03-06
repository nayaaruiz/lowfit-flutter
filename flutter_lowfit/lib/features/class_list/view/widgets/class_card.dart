import 'package:flutter/material.dart';
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/features/shared/theme/app_colors.dart';
import 'package:intl/intl.dart';

class ClassCard extends StatelessWidget {
  final ClassResponse classDetail;
  final VoidCallback onBookPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.classDetail,
    required this.onBookPressed,
    required this.onCancelPressed,
    required this.onTap,
  });

  String _formatTime(String timeStr) {
    try {
      final timeParts = timeStr.split(':');
      final now = DateTime.now();
      final time = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      return DateFormat('hh:mm a').format(time).toLowerCase();
    } catch (_) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isReserved = classDetail.isReserved;
    final bool isFull = classDetail.spacesLeft <= 0;
    
    final bool isDisabled = isFull && !isReserved;

    final String buttonLabel = isReserved ? 'Cancel' : isFull ? 'Full' : 'Book';

    final Color buttonBg = isReserved
        ? Colors.transparent
        : isFull
            ? AppColors.buttonFullBg
            : AppColors.primary;

    final Color buttonTextColor = isReserved
        ? AppColors.buttonCancel
        : isFull
            ? AppColors.buttonFullText
            : Colors.white;

    final Border? buttonBorder = isReserved
        ? Border.all(color: AppColors.buttonCancel, width: 1.5)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E38),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 110,
                height: 110,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    classDetail.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFF2E2E50),
                      child: const Icon(
                        Icons.fitness_center,
                        color: Colors.white24,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classDetail.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_formatTime(classDetail.startTime)} – ${classDetail.durationMinutes} mins',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: isReserved
                              ? onCancelPressed
                              : (isDisabled ? null : onBookPressed),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 74,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: buttonBg,
                              borderRadius: BorderRadius.circular(11),
                              border: buttonBorder,
                            ),
                            child: Text(
                              buttonLabel,
                              style: TextStyle(
                                color: buttonTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        Text(
                          isFull
                              ? '0 Spaces left'
                              : '${classDetail.spacesLeft} Spaces left',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}