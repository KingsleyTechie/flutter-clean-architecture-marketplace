import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/exceptions.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw CacheException('Failed to write secure data: $e');
    }
  }
  
  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw CacheException('Failed to read secure data: $e');
    }
  }
  
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw CacheException('Failed to delete secure data: $e');
    }
  }
  
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException('Failed to delete all secure data: $e');
    }
  }
  
  static Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      throw CacheException('Failed to read all secure data: $e');
    }
  }
  
  // Specific methods for common use cases
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    required String userId,
  }) async {
    try {
      await write('auth_token', token);
      await write('refresh_token', refreshToken);
      await write('user_id', userId);
    } catch (e) {
      throw CacheException('Failed to save auth data: $e');
    }
  }
  
  static Future<Map<String, String?>> getAuthData() async {
    try {
      final token = await read('auth_token');
      final refreshToken = await read('refresh_token');
      final userId = await read('user_id');
      
      return {
        'token': token,
        'refresh_token': refreshToken,
        'user_id': userId,
      };
    } catch (e) {
      throw CacheException('Failed to get auth data: $e');
    }
  }
  
  static Future<void> clearAuthData() async {
    try {
      await delete('auth_token');
      await delete('refresh_token');
      await delete('user_id');
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }
}
