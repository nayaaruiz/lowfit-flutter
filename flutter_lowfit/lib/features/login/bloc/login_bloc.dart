import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/models/login_request.dart';
import 'package:flutter_lowfit/core/models/login_response.dart';
import 'package:flutter_lowfit/core/services/auth_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;
  final StorageService storageService;

  LoginBloc(this.authService, this.storageService) : super(LoginInitial()) {
    on<FetchLogin>(_onFetchLogin);
  }

  Future<void> _onFetchLogin(
    FetchLogin event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final LoginResponse response = await authService.login(event.request);

      if (response.token.isEmpty) {
        throw Exception('Token no recibido');
      }

      await storageService.saveToken(response.token);
      if (response.clienteId != null) {
        await storageService.saveClienteId(response.clienteId!);
      }
      emit(LoginSuccess(response: response));
    } catch (_) {
      emit(LoginError(message: 'No se pudo iniciar sesion. Intentelo de nuevo'));
    }
  }
}
