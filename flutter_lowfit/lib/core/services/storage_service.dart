import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveClienteId(int clienteId) async {
    await _storage.write(key: 'cliente_id', value: clienteId.toString());
  }

  Future<int?> getClienteId() async {
    final value = await _storage.read(key: 'cliente_id');
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> deleteClienteId() async {
    await _storage.delete(key: 'cliente_id');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}