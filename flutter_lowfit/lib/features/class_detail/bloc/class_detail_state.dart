part of 'class_detail_bloc.dart';

sealed class ClassDetailState {}

final class ClassDetailInitial extends ClassDetailState {}

final class ClassDetailLoading extends ClassDetailState {}

final class ClassDetailSuccess extends ClassDetailState {
  final ClassResponse classDetail;

  ClassDetailSuccess({required this.classDetail});
}

final class ClassDetailError extends ClassDetailState {
  final String message;

  ClassDetailError({required this.message});
}
