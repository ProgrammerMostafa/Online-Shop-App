import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  ///////////////////////////
  static Future<Response> getData({
    required String url,
    required String language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  //////////////////////////////////
  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    required String language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return dio.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  //////////////////////////////////
  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    required String language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return dio.put(
      url,
      data: data,
      queryParameters: query,
    );
  }
}
