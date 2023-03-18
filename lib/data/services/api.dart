import 'package:dio/dio.dart';

import 'package:movie_app/utils/env.dart';

class Api {
  final Dio api = Dio();
  static String apiUrl = "https://api.themoviedb.org/3";
  static const apiKey = API_KEY;

  static Future<Response> get(
          {required String endPoint,
          String lang = 'en-US',
          int page = 1}) async =>
      await Dio().get(
        "$apiUrl$endPoint?api_key=$apiKey&language=$lang&page=$page",
      );

  static Future<Response> getSearch(
          {required String endPoint,
          required String query,
          String lang = 'en-US',
          int page = 1}) async =>
      await Dio().get(
        "$apiUrl$endPoint?api_key=$apiKey&language=$lang&page=$page&query=$query",
      );

/*Api() {
    api.options.baseUrl = apiUrl;
    api.options.receiveDataWhenStatusError = true;
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = Hive.box('data').get("") ?? "";
          debugPrint(token);

          options.headers = {
            'lang': 'en',
            'Content-Type': 'application/json',
            'Authorization': token,
          };
          return handler.next(options);
        },
      ),
    );
  }*/
}
