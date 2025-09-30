class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'No autorizado']);
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Error de conexión']);
}

class FileDownloadException implements Exception {
  final String message;

  FileDownloadException(this.message);
}
