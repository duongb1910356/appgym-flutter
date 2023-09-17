import 'package:dio/dio.dart';
import 'package:fitivation_app/shared/dio_interceptor.dart';
import 'package:fitivation_app/shared/store.service.dart';

class API {
  late final Dio _dio;

  API() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }

  Future<void> saveToken(Map<String, dynamic> data) async {
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];
    await Store.setToken(accessToken);
    await Store.setRefreshToken(refreshToken);
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } catch (error) {
      print('Error dio call API: $error');
      throw error;
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response;
    } catch (error) {
      print('Error dio call API: $error');
      throw error;
    }
  }

  Future<Response> patch(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.patch(endpoint, data: body);
      return response;
    } catch (error) {
      print('Error dio call API: $error');
      throw error;
    }
  }
}
