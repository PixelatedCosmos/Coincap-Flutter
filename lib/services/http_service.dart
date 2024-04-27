import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;
  String? _api_key;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
    _api_key = _appConfig!.COIN_API_KEY;
  }

  Future<Response?> get(String path, {String? ids, String? vsCurrency}) async {
    try {
      String url = "$_base_url$path";
      Map<String, dynamic> queryParameters = {
        'x_cg_demo_api_key': _api_key,
        'ids': ids,
        'vs_currency': vsCurrency,
      };
      Response response =
          await dio.get(url, queryParameters: queryParameters);
      return response;
    } catch (e) {
      print("HTTPService: Unable to perform get request.");
      print(e);
    }
    return null;
  }
}
