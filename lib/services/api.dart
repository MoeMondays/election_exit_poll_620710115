import 'dart:convert';
import 'package:election_exit_poll_620710115/services/api_result.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = 'https://cpsu-test-api.herokuapp.com';

  Future<dynamic> submit(String endPoint, Map<String, dynamic> params,) async {
    var url = Uri.parse('$baseUrl/$endPoint');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(params),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);

      if (apiResult.status == 'ok') {
        return apiResult.data;
      } else {
        throw apiResult.message!;
      }
    } else {
      throw 'Server connection failed!';
    }
  }

  Future<dynamic> fetch(String endPoint, {Map<String, dynamic>? queryParams,}) async {
    String queryString = Uri(queryParameters: queryParams).query;
    var url = Uri.parse('$baseUrl/$endPoint?$queryString');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);

      if (apiResult.status == 'ok') {
        return apiResult.data;
      } else {
        throw apiResult.message!;
      }
    } else {
      throw 'Server connection failed!';
    }
  }
}
