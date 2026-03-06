part of 'class_list_bloc.dart';

sealed class ClassEvent {}

class FetchClasses extends ClassEvent {
  final int? trainerId;
  FetchClasses(this.trainerId);
}

class FetchClassesForDate extends ClassEvent {
  final DateTime date;
  final int? trainerId;
  FetchClassesForDate(this.date, this.trainerId);
}

class ReserveClassEvent extends ClassEvent {
  final int classId;
  ReserveClassEvent(this.classId);
}

class CancelClassEvent extends ClassEvent {
  final int classId;
  CancelClassEvent(this.classId);
}