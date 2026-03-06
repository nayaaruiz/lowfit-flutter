import 'package:flutter_lowfit/core/models/session_progress.dart';
import 'package:flutter_lowfit/core/models/trainer_response.dart';

class HomeResponse {
  final String userName;
  final SessionProgress sessionProgress;
  final List<Trainer> trainers;

  HomeResponse({
    required this.userName,
    required this.sessionProgress,
    required this.trainers,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      userName: json['user_name'],
      sessionProgress:
          SessionProgress.fromJson(json['session_progress']),
      trainers: (json['trainers'] as List)
          .map((e) => Trainer.fromJson(e))
          .toList(),
    );
  }

}