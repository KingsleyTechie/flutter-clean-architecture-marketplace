import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../errors/exceptions.dart';
import '../constants/app_constants.dart';

class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final Connectivity connectivity;
  
  DioClient({
    required this.dio,
    required this.secureStorage,
    required this.connectivity,
  }) {
    _configureDio();
  }
  
  void _configureDio() {
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout = AppConstants.connectTimeout;
    dio.options.receiveTimeout = AppConstants.receiveTimeout;
    dio.options.sendTimeout = AppConstants.apiTimeout;
    
    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequestInterceptor,
        onResponse: _onResponseInterceptor,
        onError: _onErrorInterceptor,
      ),
    );
    
    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: true,
    ));
  }
  
  Future<void> _onRequestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check internet connection
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }
    
    // Add authorization token if available
    final token = await secureStorage.read(key: AppConstants.authTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = await _getCurrentLanguage();
    
    // Add request timestamp for security
    options.headers['X-Request-Timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
    
    return handler.next(options);
  }
  
  Future<void> _onResponseInterceptor(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // You can add response validation here
    if (response.statusCode == 401) {
      // Token expired, try to refresh
      await _refreshTokenAndRetry(response.requestOptions);
    }
    
    return handler.next(response);
  }
  
  Future<void> _onErrorInterceptor(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      // Try to refresh token
      try {
        await _refreshTokenAndRetry(error.requestOptions);
        // Retry the request
        final response = await dio.request(
          error.requestOptions.path,
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters,
          options: Options(
            method: error.requestOptions.method,
            headers: error.requestOptions.headers,
          ),
        );
        return handler.resolve(response);
      } catch (e) {
        // Refresh failed, continue with error
        return handler.next(error);
      }
    }
    
    // Handle other errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      throw ServerException('Request timeout. Please try again.');
    } else if (error.type == DioExceptionType.badResponse) {
      throw ServerException(
        error.response?.data['message'] ?? 'Server error occurred',
        statusCode: error.response?.statusCode,
      );
    } else if (error.type == DioExceptionType.unknown) {
      throw NetworkException('Network error occurred. Please check your connection.');
    }
    
    return handler.next(error);
  }
  
  Future<void> _refreshTokenAndRetry(RequestOptions options) async {
    final refreshToken = await secureStorage.read(key: AppConstants.refreshTokenKey);
    
    if (refreshToken == null) {
      throw AuthenticationFailure('Session expired. Please login again.');
    }
    
    // Call refresh token endpoint
    final response = await dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    
    if (response.statusCode == 200) {
      final newToken = response.data['token'];
      final newRefreshToken = response.data['refresh_token'];
      
      await secureStorage.write(key: AppConstants.authTokenKey, value: newToken);
      await secureStorage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken);
      
      // Update the authorization header for the retry
      options.headers['Authorization'] = 'Bearer $newToken';
    }
  }
  
  Future<String> _getCurrentLanguage() async {
    final language = await secureStorage.read(key: AppConstants.languageKey);
    return language ?? 'en';
  }
  
  // HTTP Methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
