import 'package:flutter_lowfit/core/models/trainer_response.dart';

class ClassResponse {
  final int id;
  final String name;
  final String description;
  final DateTime date;
  final String startTime;
  final int durationMinutes;
  final String image;
  final Trainer trainer;
  final bool isReserved;
  final int spacesLeft;

  ClassResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.image,
    required this.trainer,
    required this.isReserved,
    required this.spacesLeft,
  });

  factory ClassResponse.fromJson(Map<String, dynamic> json) {
    final trainerJson = json['trainer'] as Map<String, dynamic>;

    return ClassResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      durationMinutes: json['duration_minutes'] as int,
      image: json['image'] as String,
      trainer: Trainer.fromJson(trainerJson),
      isReserved: json['is_booked'] as bool? ?? false,
      spacesLeft: json['spaces_left'] as int? ?? 0,
    );
  }

  ClassResponse copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? date,
    String? startTime,
    int? durationMinutes,
    String? image,
    Trainer? trainer,
    bool? isReserved,
    int? spacesLeft,
  }) {
    return ClassResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      image: image ?? this.image,
      trainer: trainer ?? this.trainer,
      isReserved: isReserved ?? this.isReserved,
      spacesLeft: spacesLeft ?? this.spacesLeft,
    );
  }
}
