import 'package:dio/dio.dart';
import 'package:fitivation_app/shared/store.service.dart';

class DioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Content-Type'] = 'application/json';
    options.connectTimeout = 5000;
    options.receiveTimeout = 3000;
    final token = await Store.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
