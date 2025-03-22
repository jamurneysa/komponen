import 'dart:convert';

import 'function_string.dart';
import 'package:http/http.dart' as http;

import 'env.dart';

class ApiService {
  Future<List?> getUrlData({String? path, Map<String, dynamic>? query}) async {
    path = path ?? 'exec';
    try {
      /* if (kIsWeb) {
    http.Response response;
        response = await http.get(Uri.http(Env.baseUrl, path, query));
      } else {
        response = await http.get(Uri.https(Env.baseUrl, path, query));
      } */

      var response = await http.get(Uri.https(Env.baseUrl, path, query));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic>) {
          return [jsonResponse];
        }
        return jsonResponse;
      } else {
        dp('Request failed with status: ${response.statusCode}.');
        dp('res: ${response.body}.');
        return null;
      }
    } catch (e, stackTrace) {
      dp("getUrlData\nerror :\n $e\nstackTrace : $stackTrace");
      return null;
    }
  }
}
