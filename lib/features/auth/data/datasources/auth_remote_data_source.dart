import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<Unit> logout();
  Future<User> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  
  AuthRemoteDataSourceImpl({required this.dio});
  
  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return User(
          id: data['id'],
          email: data['email'],
          name: data['name'],
          token: data['token'],
          refreshToken: data['refresh_token'],
        );
      } else {
        throw ServerException(
          response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
  
  @override
  Future<User> register(String email, String password, String name) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      
      if (response.statusCode == 201) {
        final data = response.data['data'];
        return User(
          id: data['id'],
          email: data['email'],
          name: data['name'],
          token: data['token'],
          refreshToken: data['refresh_token'],
        );
      } else {
        throw ServerException(
          response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Registration failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
  
  @override
  Future<Unit> logout() async {
    try {
      final response = await dio.post('/auth/logout');
      
      if (response.statusCode == 200) {
        return unit;
      } else {
        throw ServerException(
          response.data['message'] ?? 'Logout failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
  
  @override
  Future<User> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return User(
          id: data['id'],
          email: data['email'],
          name: data['name'],
          token: data['token'],
          refreshToken: data['refresh_token'],
        );
      } else {
        throw ServerException(
          response.data['message'] ?? 'Token refresh failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Token refresh failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
