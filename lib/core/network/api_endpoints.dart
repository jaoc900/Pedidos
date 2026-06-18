class ApiEndpoints {
  static const String baseUrl = "http://192.168.0.103:5184";

  // =========================
  // PRODUCTS (Articles)
  // =========================
  static const String products = "/api/products";
  static const String productById = "/api/products/{id}";
  static const String createProduct = "/api/products";
  static const String updateProduct = "/api/products/{id}";
  static const String deleteProduct = "/api/products/{id}";
  static const String uploadProductPhoto = "/api/products/{id}/upload-photo";
  static const String addProductVariant = "/api/products/{id}/variants";
  static const String updateProductVariant = "/api/products/variants/{variantId}";
  static const String deleteProductVariant = "/api/products/variants/{variantId}";
  static const String adjustStock = "/api/products/variants/{variantId}/stock";
  static const String productCategories = "/api/products/categories";

  // =========================
  // AUTH
  // =========================
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String logout = "/api/auth/logout";
  static const String refreshToken = "/api/auth/refresh";
  static const String changePassword = "/api/auth/change-password";

  // =========================
  // EMPLOYEES
  // =========================
  static const String employees = "/api/employees";
  static const String employeeById = "/api/employees/{id}";
  static const String employeeStats = "/api/employees/stats";
  static const String employeeSales = "/api/employees/sales";
  static const String activeEmployees = "/api/employees/active";
  static const String resetEmployeePassword = "/api/employees/{id}/reset-password";

  // Employee Roles endpoints
  static const String employeeRoles = "/api/employee-roles";
  static const String employeeRoleById = "/api/employee-roles/{id}";
  static const String employeeRoleAssign = "/api/employee-roles/assign";
  static const String employeeRolesSimpleList = "/api/employee-roles/simple-list";

  // =========================
  // EXPENSES
  // =========================
  static const String expenses = "/api/expenses";
  static const String expenseById = "/api/expenses/{id}";
  static const String createExpense = "/api/expenses";
  static const String updateExpense = "/api/expenses/{id}";
  static const String deleteExpense = "/api/expenses/{id}";
  static const String uploadExpenseReceipt = "/api/expenses/{id}/receipt";

  // Categories
  static const String expenseCategories = "/api/expenses/categories";
  static const String expenseCategoryById = "/api/expenses/categories/{id}";
  static const String activeExpenseCategories = "/api/expenses/categories/active";

  // =========================
  // INVENTORY
  // =========================
  static const String inventory = "/api/inventory";
  static const String inventoryAlerts = "/api/inventory/alerts";

  // =========================
  // ORDERS
  // =========================
  static const String orders = "/api/orders";
  static const String orderById = "/api/orders/{id}";
  static const String updateOrderStatus = "/api/orders/{id}/status";

  // =========================
  // PAYMENT METHODS
  // =========================
  static const String paymentMethods = "/api/payment-methods";
  static const String paymentMethodById = "/api/payment-methods/{id}";
  static const String togglePaymentMethodStatus = "/api/payment-methods/{id}/toggle-status";
  static const String activePaymentMethods = "/api/payment-methods/active";
  static const String seedPaymentMethods = "/api/payment-methods/seed-defaults";

  // =========================
  // POS
  // =========================
  static const String posProducts = "/api/pos/products";
  static const String posCustomerSearch = "/api/pos/customers/search";
  static const String posSaleById = "/api/pos/sales/{id}";
  static const String posSales = "/api/pos/sales";
  static const String posSessionSummary = "/api/pos/session/{id}/summary";
  static const String posDiscounts = "/api/pos/discounts";

  // =========================
  // PRICE LISTS
  // =========================
  static const String priceLists = "/api/price-lists";
  static const String priceListById = "/api/price-lists/{id}";
  static const String priceListProducts = "/api/price-lists/{id}/products";
  static const String updatePriceListProduct = "/api/price-lists/{id}/products/{productId}";
  static const String deletePriceListProduct = "/api/price-lists/{id}/products/{productId}";
  static const String bulkUpdatePrices = "/api/price-lists/{id}/products/bulk";
  static const String copyPriceList = "/api/price-lists/{id}/copy-from/{sourceId}";

  // =========================
  // PROFILE
  // =========================
  static const String profile = "/api/profile";
  static const String updateProfile = "/api/profile";
  static const String changeProfilePassword = "/api/profile/change-password";
  static const String uploadProfilePhoto = "/api/profile/upload-photo";
  static const String deleteProfilePhoto = "/api/profile/photo";

  static const String notifications = "/api/profile/notifications";
  static const String markNotificationRead = "/api/profile/notifications/{id}/read";
  static const String markAllNotificationsRead = "/api/profile/notifications/read-all";
  static const String deleteNotification = "/api/profile/notifications/{id}";
  static const String unreadNotificationsCount = "/api/profile/notifications/unread-count";

  // =========================
  // SUPPLIERS
  // =========================
  static const String suppliers = "/api/suppliers";
  static const String supplierById = "/api/suppliers/{id}";
  static const String supplierStats = "/api/suppliers/stats";
  static const String activeSuppliers = "/api/suppliers/active";
  static const String supplierBalance = "/api/suppliers/{id}/balance";
  static const String suppliersByCategory = "/api/suppliers/category/{category}";

  // =========================
  // USER PREFERENCES
  // =========================
  static const String userPreferences = "/api/user-preferences";
  static const String userPreferencesByUser = "/api/user-preferences/{userId}";
  static const String userPreferencesSendSms = "/api/user-preferences/sendsms";
  static const String userPreferencesSendPush = "/api/user-preferences/sendpush";
  static const String userPreferencesReset = "/api/user-preferences/reset";
}