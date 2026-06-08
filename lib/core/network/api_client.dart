import 'http_client.dart';
import 'api_endpoints.dart';

class ApiClient {
  final HttpClient _httpClient;

  ApiClient(this._httpClient);

  // Auth methods
  Future<dynamic> login(String email, String password) async {
    return await _httpClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<dynamic> register(Map<String, dynamic> userData) async {
    return await _httpClient.post(
      ApiEndpoints.register,
      data: userData,
    );
  }

  Future<dynamic> logout() async {
    return await _httpClient.post(ApiEndpoints.logout);
  }

  // User methods
  Future<dynamic> getProfile() async {
    return await _httpClient.get(ApiEndpoints.profile);
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    return await _httpClient.put(ApiEndpoints.updateProfile, data: data);
  }

  // Orders methods
  Future<dynamic> getOrders({Map<String, dynamic>? filters}) async {
    return await _httpClient.get(
      ApiEndpoints.orders,
      queryParameters: filters,
    );
  }

  Future<dynamic> createOrder(Map<String, dynamic> orderData) async {
    return await _httpClient.post(ApiEndpoints.orders, data: orderData);
  }

  // Products methods
  Future<dynamic> getProducts({Map<String, dynamic>? filters}) async {
    return await _httpClient.get(
      ApiEndpoints.products,
      queryParameters: filters,
    );
  }

}