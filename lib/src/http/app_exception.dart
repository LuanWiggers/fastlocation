/// Erro de negócio/comunicação com mensagem pronta para o usuário.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
