import 'package:flutter/material.dart';
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/features/class_list/view/widgets/class_card.dart';
import 'package:flutter_lowfit/features/class_detail/view/class_detail_page.dart';

class ClassList extends StatelessWidget {
  const ClassList({
    super.key,
    required this.classes,
    required this.onBookPressed,
    required this.onCancelPressed, // 1. Añadimos el parámetro al constructor
  });

  final List<ClassResponse> classes;
  final ValueChanged<int> onBookPressed;
  final ValueChanged<int> onCancelPressed; // 2. Lo declaramos como variable

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return const Center(
        child: Text(
          'No classes found',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: classes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ClassResponse classDetail = classes[index];

        return ClassCard(
          classDetail: classDetail,

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClassDetailPage(
                  classId: classDetail.id,
                ),
              ),
            );
          },

          onBookPressed: () => onBookPressed(classDetail.id),
          
          onCancelPressed: () => onCancelPressed(classDetail.id), 
        );
      },
    );
  }
}