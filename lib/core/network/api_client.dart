import 'http_client.dart';
import 'api_endpoints.dart';
import 'dart:io';

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

  Future<dynamic> changePassword(Map<String, dynamic> data) async {
    return await _httpClient.post(ApiEndpoints.changePassword, data: data);
  }

  Future<dynamic> uploadProfilePhoto(File imageFile) async {
    // Si tu API espera multipart/form-data
    return await _httpClient.uploadFile(
        ApiEndpoints.uploadProfilePhoto, imageFile, 'file');
  }

  Future<dynamic> deleteProfilePhoto() async {
    return await _httpClient.delete(ApiEndpoints.deleteProfilePhoto);
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

  // Payment Methods methods
  Future<dynamic> getPaymentMethods() async {
    return await _httpClient.get(ApiEndpoints.paymentMethods);
  }

  Future<dynamic> getPaymentMethodById(String id) async {
    final endpoint = ApiEndpoints.paymentMethodById.replaceAll('{id}', id);
    return await _httpClient.get(endpoint);
  }

  Future<dynamic> createPaymentMethod(Map<String, dynamic> data) async {
    return await _httpClient.post(ApiEndpoints.paymentMethods, data: data);
  }

  Future<dynamic> updatePaymentMethod(String id,
      Map<String, dynamic> data) async {
    final endpoint = ApiEndpoints.paymentMethodById.replaceAll('{id}', id);
    return await _httpClient.put(endpoint, data: data);
  }

  Future<dynamic> deletePaymentMethod(String id) async {
    final endpoint = ApiEndpoints.paymentMethodById.replaceAll('{id}', id);
    return await _httpClient.delete(endpoint);
  }

  Future<dynamic> togglePaymentMethodStatus(String id) async {
    final endpoint = ApiEndpoints.togglePaymentMethodStatus.replaceAll(
        '{id}', id);
    return await _httpClient.patch(endpoint);
  }

  Future<dynamic> getActivePaymentMethods() async {
    return await _httpClient.get(ApiEndpoints.activePaymentMethods);
  }

  Future<dynamic> seedDefaultPaymentMethods() async {
    return await _httpClient.post(ApiEndpoints.seedPaymentMethods);
  }

  Future<dynamic> getExpenseCategories() async {
    return await _httpClient.get(ApiEndpoints.expenseCategories);
  }

  Future<dynamic> getExpenseCategoryById(String id) async {
    final endpoint = ApiEndpoints.expenseCategoryById.replaceAll('{id}', id);
    return await _httpClient.get(endpoint);
  }

  Future<dynamic> createExpenseCategory(Map<String, dynamic> data) async {
    return await _httpClient.post(ApiEndpoints.expenseCategories, data: data);
  }

  Future<dynamic> updateExpenseCategory(String id,
      Map<String, dynamic> data) async {
    final endpoint = ApiEndpoints.expenseCategoryById.replaceAll('{id}', id);
    return await _httpClient.put(endpoint, data: data);
  }

  Future<void> deleteExpenseCategory(String id) async {
    final endpoint = ApiEndpoints.expenseCategoryById.replaceAll('{id}', id);
    await _httpClient.delete(endpoint);
  }

  Future<dynamic> getActiveExpenseCategories() async {
    return await _httpClient.get(ApiEndpoints.activeExpenseCategories);
  }

  // Obtener todos los empleados
  Future<dynamic> getEmployees() async {
    return await _httpClient.get(ApiEndpoints.employees);
  }

// Obtener empleado por ID
  Future<dynamic> getEmployeeById(String id) async {
    final endpoint = ApiEndpoints.employeeById.replaceAll('{id}', id);
    return await _httpClient.get(endpoint);
  }

// Obtener estadísticas de empleados
  Future<dynamic> getEmployeeStats() async {
    return await _httpClient.get(ApiEndpoints.employeeStats);
  }

// Obtener ventas por empleado
  Future<dynamic> getEmployeeSales() async {
    return await _httpClient.get(ApiEndpoints.employeeSales);
  }

// Obtener empleados activos
  Future<dynamic> getActiveEmployees() async {
    return await _httpClient.get(ApiEndpoints.activeEmployees);
  }

// Crear empleado
  Future<dynamic> createEmployee(Map<String, dynamic> data) async {
    return await _httpClient.post(ApiEndpoints.employees, data: data);
  }

// Actualizar empleado
  Future<dynamic> updateEmployee(String id, Map<String, dynamic> data) async {
    final endpoint = ApiEndpoints.employeeById.replaceAll('{id}', id);
    return await _httpClient.put(endpoint, data: data);
  }

// Eliminar empleado
  Future<void> deleteEmployee(String id) async {
    final endpoint = ApiEndpoints.employeeById.replaceAll('{id}', id);
    await _httpClient.delete(endpoint);
  }

// Cambiar estado del empleado (activar/desactivar)
  Future<dynamic> toggleEmployeeStatus(String id, bool isActive) async {
    final endpoint = ApiEndpoints.employeeById.replaceAll('{id}', id);
    return await _httpClient.patch(endpoint, data: {'isActive': isActive});
  }

// Restablecer contraseña
  Future<void> resetEmployeePassword(String id) async {
    final endpoint = ApiEndpoints.resetEmployeePassword.replaceAll('{id}', id);
    await _httpClient.post(endpoint);
  }

  /// Obtener todos los roles de empleados
  /// GET /api/employee-roles
  Future<dynamic> getEmployeeRoles() async {
    return await _httpClient.get(ApiEndpoints.employeeRoles);
  }

  /// Obtener un rol por ID
  /// GET /api/employee-roles/{id}
  Future<dynamic> getEmployeeRoleById(String id) async {
    final endpoint = ApiEndpoints.employeeRoleById.replaceAll('{id}', id);
    return await _httpClient.get(endpoint);
  }

  /// Crear un nuevo rol de empleado
  /// POST /api/employee-roles
  Future<dynamic> createEmployeeRole(Map<String, dynamic> data) async {
    return await _httpClient.post(ApiEndpoints.employeeRoles, data: data);
  }

  /// Actualizar un rol de empleado existente
  /// PUT /api/employee-roles/{id}
  Future<dynamic> updateEmployeeRole(String id, Map<String, dynamic> data) async {
    final endpoint = ApiEndpoints.employeeRoleById.replaceAll('{id}', id);
    return await _httpClient.put(endpoint, data: data);
  }

  /// Eliminar un rol de empleado
  /// DELETE /api/employee-roles/{id}
  Future<void> deleteEmployeeRole(String id) async {
    final endpoint = ApiEndpoints.employeeRoleById.replaceAll('{id}', id);
    await _httpClient.delete(endpoint);
  }

  /// Asignar un rol a un empleado
  /// POST /api/employee-roles/assign
  Future<dynamic> assignRoleToEmployee(Map<String, dynamic> data) async {
    return await _httpClient.post(ApiEndpoints.employeeRoleAssign, data: data);
  }

  /// Obtener lista simple de roles (para dropdowns)
  /// GET /api/employee-roles/simple-list
  Future<dynamic> getEmployeeRolesSimpleList() async {
    return await _httpClient.get(ApiEndpoints.employeeRolesSimpleList);
  }
}