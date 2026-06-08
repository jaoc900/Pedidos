import 'package:get_it/get_it.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Singleton instances
  locator.registerLazySingleton<HttpClient>(() => HttpClient());
  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator<HttpClient>()));
}