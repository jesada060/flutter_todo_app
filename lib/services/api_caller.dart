import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiCaller {
  static const baseUrl = 'http://localhost:3000';
  static final _dio = Dio(BaseOptions(responseType: ResponseType.plain));

  Future<String> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response =
          await _dio.get('$baseUrl/$endpoint', queryParameters: params);
      debugPrint(response.data.toString());
      return response.data.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> post(String endpoint,
      {required Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.post('$baseUrl/$endpoint', data: params);
      debugPrint(response.data.toString());
      return response.data.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> put(String endpoint,
      {required String id, required Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.put('$baseUrl/$endpoint/$id', data: params);
      debugPrint(response.data.toString());
      return response.data.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String endpoint, {required String id}) async {
    try {
      await _dio.delete('$baseUrl/$endpoint/$id');
    } catch (e) {
      rethrow;
    }
  }
}
