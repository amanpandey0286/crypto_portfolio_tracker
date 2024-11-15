import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:portfolio_tracker/consts.dart';

class HttpService {
  final Dio _dio = Dio();

  HttpService() {
    _configureDio();
  }

  // configuring dio with baseoption
  void _configureDio() {
    _dio.options =
        BaseOptions(baseUrl: 'https://api.cryptorank.io/v1/', queryParameters: {
      'api_key': CRYPTO_RANK_API_KEY,
    });
  }

  //perform get request
  Future<dynamic> getResponse(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      log(e.toString());
    }
  }
}
