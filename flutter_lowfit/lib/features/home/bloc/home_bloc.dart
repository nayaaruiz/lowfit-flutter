import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/models/home_response.dart';
import 'package:flutter_lowfit/core/services/home_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService homeService;
  final StorageService storageService;

  HomeBloc(this.homeService, this.storageService)
      : super(HomeInitial()) {
    on<FetchHome>(_onFetchHome);
  }

  Future<void> _onFetchHome(
    FetchHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final token = await storageService.getToken();

      if (token == null) {
        emit(HomeError(message: 'Token no encontrado'));
        return;
      }

      final HomeResponse response =
          await homeService.getHome(token);

      emit(HomeSuccess(response: response));
    } catch (e) {
      emit(HomeError(message: e.toString()));
      //emit(HomeError(message: 'Error al cargar el inicio'));
    }
  }
}
