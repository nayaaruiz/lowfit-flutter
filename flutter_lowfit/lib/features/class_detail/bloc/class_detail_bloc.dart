import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/core/services/class_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';

part 'class_detail_event.dart';
part 'class_detail_state.dart';

class ClassDetailBloc extends Bloc<ClassDetailEvent, ClassDetailState> {
  final ClassService classService;
  final StorageService storageService;

  ClassDetailBloc(this.classService, this.storageService)
      : super(ClassDetailInitial()) {
    on<FetchClassDetail>(_onFetchClassDetail);
    on<ReserveSessionEvent>(_reserveEvent);
  }

  Future<void> _onFetchClassDetail(
    FetchClassDetail event,
    Emitter<ClassDetailState> emit,
  ) async {
    emit(ClassDetailLoading());

    try {
      final token = await storageService.getToken();

      if (token == null) {
        emit(ClassDetailError(message: 'Token no encontrado'));
        return;
      }

      final ClassResponse detail =
          await classService.getClassDetail(event.id, token);
      emit(ClassDetailSuccess(classDetail: detail));
    } catch (_) {
      emit(ClassDetailError(message: 'Error al cargar la clase'));
    }
  }

  Future<void> _reserveEvent(
    ReserveSessionEvent event,
    Emitter<ClassDetailState> emit,
  ) async {
    if (state is! ClassDetailSuccess) return;

    try {
      final token = await storageService.getToken();

      if (token == null) {
        emit(ClassDetailError(message: 'Token no encontrado'));
        return;
      }

      await classService.reserveEvent(event.id, token);

      final ClassResponse updatedClassDetail =
          await classService.getClassDetail(event.id, token);
      emit(ClassDetailSuccess(classDetail: updatedClassDetail));
    } catch (_) {
      emit(ClassDetailError(message: 'Error al reservar la clase'));
    }
  }
}
