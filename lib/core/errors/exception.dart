class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  const AppException(this.message, {this.statusCode});
  
  @override
  String toString() => 'AppException: $message${statusCode != null ? ' ($statusCode)' : ''}';
}

class ServerException extends AppException {
  const ServerException(String message, {int? statusCode}) 
      : super(message, statusCode: statusCode);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}
