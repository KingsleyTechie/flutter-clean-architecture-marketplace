class AppConstants {
  static const String appName = 'Marketplace Boilerplate';
  static const String baseUrl = 'https://api.marketplace.com/v1';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'app_language';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 30);
}
