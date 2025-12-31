import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/secure_storage.dart';
import '../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<User?> getCachedUser();
  Future<Unit> cacheUser(User user);
  Future<Unit> clearCache();
  Future<String?> getToken();
  Future<Unit> cacheToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<User?> getCachedUser() async {
    try {
      final userData = await SecureStorage.read('user_data');
      if (userData == null) return null;
      
      // Parse user data (simplified - in real app use JSON serialization)
      final parts = userData.split('|');
      if (parts.length >= 3) {
        return User(
          id: parts[0],
          email: parts[1],
          name: parts[2],
          token: await getToken(),
        );
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }
  
  @override
  Future<Unit> cacheUser(User user) async {
    try {
      final userData = '${user.id}|${user.email}|${user.name}';
      await SecureStorage.write('user_data', userData);
      return unit;
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }
  
  @override
  Future<Unit> clearCache() async {
    try {
      await SecureStorage.delete('user_data');
      await SecureStorage.delete('auth_token');
      await SecureStorage.delete('refresh_token');
      return unit;
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await SecureStorage.read('auth_token');
    } catch (e) {
      throw CacheException('Failed to get token: $e');
    }
  }
  
  @override
  Future<Unit> cacheToken(String token) async {
    try {
      await SecureStorage.write('auth_token', token);
      return unit;
    } catch (e) {
      throw CacheException('Failed to cache token: $e');
    }
  }
}
