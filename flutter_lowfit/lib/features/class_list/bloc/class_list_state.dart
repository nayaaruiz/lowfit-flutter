part of 'class_list_bloc.dart';

sealed class ClassState {}

final class ClassInitial extends ClassState {}

final class ClassLoading extends ClassState {}

final class ClassLoaded extends ClassState {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final List<ClassResponse> classes;

  ClassLoaded({
    required this.dates,
    required this.selectedDate,
    required this.classes,
  });
}

final class ClassError extends ClassState {
  final String message;

  ClassError({required this.message});
}