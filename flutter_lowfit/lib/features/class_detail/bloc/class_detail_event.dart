part of 'class_detail_bloc.dart';

sealed class ClassDetailEvent {}

final class FetchClassDetail extends ClassDetailEvent {
  final int id;

  FetchClassDetail({required this.id});
}

final class ReserveSessionEvent extends ClassDetailEvent {
  final int id;

  ReserveSessionEvent({required this.id});
}
