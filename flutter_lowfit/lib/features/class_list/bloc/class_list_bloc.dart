import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/core/services/class_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';

part 'class_list_event.dart';
part 'class_list_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassService classService;
  final StorageService storageService;

  ClassBloc(this.classService, this.storageService) : super(ClassInitial()) {
    on<FetchClasses>(_onFetchClasses);
    on<FetchClassesForDate>(_onFetchClassesForDate);
    on<ReserveClassEvent>(_reserveEvent);
    on<CancelClassEvent>(_onCancelReserve);
  }

  Future<void> _onFetchClasses(
    FetchClasses event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(ClassError(message: 'Token no encontrado'));
        return;
      }

      final (minDate, maxDate) = await classService.getClassRange(token);

      final dates = List<DateTime>.generate(
        maxDate.difference(minDate).inDays + 1,
        (index) => minDate.add(Duration(days: index)),
      );

      final classes = await classService.getClassesForDate(
        dates.first,
        token,
        trainerId: event.trainerId,
      );

      emit(ClassLoaded(
        dates: dates,
        selectedDate: dates.first,
        classes: classes,
      ));
    } catch (e) {
      emit(ClassError(message: e.toString()));
    }
  }

  Future<void> _onFetchClassesForDate(
    FetchClassesForDate event,
    Emitter<ClassState> emit,
  ) async {
    if (state is! ClassLoaded) return;

    final currentState = state as ClassLoaded;

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(ClassError(message: 'Token no encontrado'));
        return;
      }

      final classes = await classService.getClassesForDate(
        event.date,
        token,
        trainerId: event.trainerId,
      );

      emit(ClassLoaded(
        dates: currentState.dates,
        selectedDate: event.date,
        classes: classes,
      ));
    } catch (e) {
      emit(ClassError(message: e.toString()));
    }
  }

  Future<void> _reserveEvent(
    ReserveClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    if (state is! ClassLoaded) return;

    final currentState = state as ClassLoaded;

    emit(ClassLoading());

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(ClassError(message: 'Token no encontrado'));
        return;
      }

      // use class-level booking endpoint; backend returns the updated class
      final updatedClass =
          await classService.bookClass(event.classId, token);

      final updatedClasses = currentState.classes.map((classItem) {
        if (classItem.id == event.classId) {
          return updatedClass;
        }
        return classItem;
      }).toList();

      emit(ClassLoaded(
        dates: currentState.dates,
        selectedDate: currentState.selectedDate,
        classes: updatedClasses,
      ));
    } catch (e) {
      // for a 409 we simply mark it reserved locally in case the backend
      // already had a booking (prevents double-tap issues)
      if (e.toString().contains('409')) {
        final updatedClasses = currentState.classes.map((classItem) {
          if (classItem.id == event.classId) {
            return classItem.copyWith(isReserved: true);
          }
          return classItem;
        }).toList();

        emit(ClassLoaded(
          dates: currentState.dates,
          selectedDate: currentState.selectedDate,
          classes: updatedClasses,
        ));
      } else {
        emit(ClassError(message: e.toString()));
      }
    }
  }

  Future<void> _onCancelReserve(
    CancelClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    if (state is! ClassLoaded) return;

    final currentState = state as ClassLoaded;

    emit(ClassLoading());

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(ClassError(message: 'Token no encontrado'));
        return;
      }

      // cancel via class endpoint
      final updatedClass =
          await classService.cancelClass(event.classId, token);

      final updatedClasses = currentState.classes.map((classItem) {
        if (classItem.id == event.classId) {
          return updatedClass;
        }
        return classItem;
      }).toList();

      emit(ClassLoaded(
        dates: currentState.dates,
        selectedDate: currentState.selectedDate,
        classes: updatedClasses,
      ));
    } catch (e) {
      // treat 404 as already cancelled / no reservation
      if (e.toString().contains('404')) {
        final updatedClasses = currentState.classes.map((classItem) {
          if (classItem.id == event.classId) {
            return classItem.copyWith(isReserved: false);
          }
          return classItem;
        }).toList();

        emit(ClassLoaded(
          dates: currentState.dates,
          selectedDate: currentState.selectedDate,
          classes: updatedClasses,
        ));
      } else {
        emit(ClassError(message: e.toString()));
      }
    }
  }
}